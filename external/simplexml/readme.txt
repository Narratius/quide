SimpleXML.pas is a library for XML parsing and converting to XML objects hierarchy and vice versa. This is a revised version of SimpleXML.pas introduced by Michael Vlasov in 2003. It is one of the smallest and fastest XML librarys availably for Delphi. The new version is not fully compatible to the old one, mainly because now the character conversion is done internal and not outside the library, as it was before. The format of the binary dump is changed, too. 

Why using SimpleXML.pas?
========================
- small footprint
- faster as MSXML and several other libraries
- internal character conversion
- compatible with Unicode Delphi (2009)

Limits of SimpleXML.pas
=======================
- no UTF-16/32-File support
- only a limited number of character set are supported: 
  UTF-8, WINDOWS-1250..WINDOWS-1258, ISO-8859-1..ISO-8859-9
- No support for UFT8-Codes exceed 3 Bytes (Unicode Basic Multilingual Plane only)

Introduction for using SimpleXML.pas
====================================
LoadXmlDocument 
  create a new Instance of IXmlDocument. Now you are ready to use the XML data.
  
SelectSingleNode
  Return a IXmlNode object or nil if the specified can not found. You can indicate a complete path.
  Examble: XmlNode := XMLDoc.SelectSingleNode('data\fields')
  
SelectNodes
  Return a list of nodes with specified name.
  Examble: XmlNodeList := XMLDoc.SelectNodes('data\fields\field');
            (Get all child nodes of the node "fields" with the name "field")
  
IXmlNode.Text
  Get and set text(s) of the node. Text is saved as separate child node. This preserve the
  position of the text in the XML tree.
  
IXmlNode.NodeName
  Return the name of the node

IXmlNode.AppendElement()
  Append a new child node to the current node

IXmlNode.NeedAttr()
  Return Attribut string of an attribut with specified name or AttrNameID (see below).
  
IXmlNode.AttrNames[Index]
  Return Attribut name for given index.
  
IXmlNode.AttrNameIDs[Index]
  Return special "magic" number to identify a attribut in a fast way. This number is 
  valid as long the same name table is used.

IXmlDocument.Save()
  Save the XML document to a file or stream.

Performance Hint
================
If you have to load/create very large XML-Files with many different names, you should create your own name table.
Example for 3.000.000 Nodes:
XMLDoc := CreateXmlDocument('', '', '', CreateNameTable(2029));
Try different table sizes to get the best compromise between speed and memory requirements. You can not benefit from the greater name table, if your XML-file have a lot of nodes/attributs with the same name. 