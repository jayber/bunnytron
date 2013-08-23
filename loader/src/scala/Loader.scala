import scala.xml.Elem

val document: Elem = xml.XML.loadFile(args(0))

//    println(document)
println((document \ "service" \ "practiceAreaList" \ "practiceArea" \ "name").sortBy(_.text).mkString("\n"))

