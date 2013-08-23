import java.util
import org.springframework.web.client.RestTemplate
import scala.xml.{Node, NodeSeq, Elem}

val document: Elem = xml.XML.loadFile(args(0))

val topLevelPracticeAreas: NodeSeq = document \ "service" \ "practiceAreaList" \ "practiceArea"

topLevelPracticeAreas.foreach(loadNode(_, Option("")))

val rest: RestTemplate = new RestTemplate()

def loadNode(node: Node, parentName: Option[String]): Unit = {
  val map: util.HashMap[String, String] = new util.HashMap[String, String]()
  val nodeName: String = (node \ "name").text
  map.put("name", nodeName)
  map.put("parentName", parentName.getOrElse(""))

  println(s"/${parentName.getOrElse("")}/$nodeName")
  //  rest.postForLocation(new URI("http://localhost:8080/"), map)

  (node \ "practiceAreaList" \ "practiceArea").foreach(loadNode(_, Option(nodeName)))
}
