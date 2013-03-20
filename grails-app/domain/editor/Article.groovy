package editor

class Article {

    static constraints = {
        title blank: false
        author blank: false
        body blank: true, size: 0..1000000
        service nullable: true, blank: true
        maintained nullable: false
        maintainDate nullable: true, blank: true
    }

    String title = ""
    Person author
    String body = ""
    Date createdDate = new Date()
    Boolean maintained = false
    Date maintainDate
    TElement service
}
