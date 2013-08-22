package taxonomy

class SubjectArea {

    static mapWith = "neo4j"

    static constraints = {
        name nullable: false
        plcRef nullable: false
        parent nullable: true, blank: true
    }

    String name
    String plcRef

    SubjectArea parent

    @Override
    String toString() {
        "$name - $plcRef"
    }
}
