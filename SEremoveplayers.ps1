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
              $selectdelete = $myXML2.SelectSingleNode("//Factions/Factions/MyObjectBuilder_Faction/Members/MyObjectBuilder_FactionMember[PlayerID='$nodeid']" , $ns2)
              $selectdelete.ParentNode.RemoveChild($selectdelete)
              $selectdelete = $myXML2.SelectSingleNode("//Factions/Players/dictionary/item[Key='$nodeid']", $ns2)
              $selectdelete.ParentNode.RemoveChild($selectdelete)
              $selectdelete = $myXML2.SelectSingleNode("//Factions/Factions/MyobjectBuilder_Faction/JoinRequests/MyObjectBuilder_FactionMember[PlayerID='$nodeid']" , $ns2)
              $selectdelete.ParentNode.RemoveChild($selectdelete)
              $node.ParentNode.RemoveChild($node)
            }
        
           

    }

    $myXML.Save($filePath)

