$filePath = 'your save path here\SANDBOX_0_0_0_.sbs'
$filePath2 = 'your save path here\SANDBOX.sbc'

# ===== only change the above values

[xml]$myXML = Get-Content $filePath
$ns = New-Object System.Xml.XmlNamespaceManager($myXML.NameTable)
$ns.AddNamespace("xsi", "http://www.w3.org/2001/XMLSchema-instance")

[xml]$myXML2 = Get-Content $filePath2
$ns2 = New-Object System.Xml.XmlNamespaceManager($myXML2.NameTable)
$ns2.AddNamespace("xsi", "http://www.w3.org/2001/XMLSchema-instance")


# remove players who dont own anything    

    $nodePIDs = $myXML2.SelectNodes("//AllPlayers/PlayerItem"  , $ns2) 
    ForEach($node in $nodePIDs){
        $nodeid = $node.PlayerId
        $nodeOwns = $myXML.SelectNodes("//SectorObjects/MyObjectBuilder_EntityBase[(@xsi:type='MyObjectBuilder_CubeGrid')]/CubeBlocks/MyObjectBuilder_CubeBlock[Owner='$nodeid']"  , $ns).Count
            If($nodeOwns -eq 0){
              $selectdelete = $myXML2.SelectSingleNode("//Factions/Factions/MyObjectBuilder_Faction/Members/MyObjectBuilder_FactionMember[PlayerId='$nodeid']" , $ns2)
              $selectdelete.ParentNode.RemoveChild($selectdelete)
              $selectdelete = $myXML2.SelectSingleNode("//Factions/Players/dictionary/item[Key='$nodeid']", $ns2)
              $selectdelete.ParentNode.RemoveChild($selectdelete)
              $selectdelete = $myXML2.SelectSingleNode("//Factions/Factions/MyobjectBuilder_Faction/JoinRequests/MyObjectBuilder_FactionMember[PlayerId='$nodeid']" , $ns2)
              $selectdelete.ParentNode.RemoveChild($selectdelete)
              $node.ParentNode.RemoveChild($node)
            }
    }
#remove empty factions
    $nodeFactions = $myXML2.SelectNodes("//Factions/Factions/MyObjectBuilder_Faction" , $ns2)
    ForEach($faction in $nodeFactions){
        $membercount = $faction.Members.MybObjectBuilder_FactionMember.count
        $factionid = $faction.FactionId
        If($membercount -eq 0){
            $selectdelete = $myXML2.SelectNodes("//Factions/Requests/MyObjectBuilder_FactionRequests[FactionId='$factionid']" , $ns2)
            ForEach($selected in $selectdelete){
                $selected.ParentNode.RemoveChild($selected)
            }
            $selectdelete = $myXML2.SelectNodes("//Factions/Relations/MyObjectBuilder_FactionRelation[FactionId1='$factionid' or FactionId2='$factionid']" , $ns2)
            ForEach($selected in $selectdelete){
                $selected.ParentNode.RemoveChild($selected)
            }
            $faction.ParentNode.RemoveChild($faction)
            $deletefactions = $deletefactions + 1
        }
    }

    $myXML.Save($filePath)
    $myXML2.Save($filePath2)

