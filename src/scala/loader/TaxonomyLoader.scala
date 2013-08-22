package loader

import scala.xml.Elem

object TaxonomyLoader {
  def main(args: Array[String]) {
    val document: Elem = xml.XML.loadFile(args(0))



    //    println(document)
    println((document \ "service" \ "practiceAreaList" \ "practiceArea" \ "name").sortBy(_.text).mkString("\n"))


  }
}
