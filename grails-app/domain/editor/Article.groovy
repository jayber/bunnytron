package editor

class Article {

    static constraints = {
        title blank: false
        author blank: false
        body blank: true, size: 0..1000000
    }

    String title = ""
    Person author
    String body = ""
    Date createdDate = new Date()
}
