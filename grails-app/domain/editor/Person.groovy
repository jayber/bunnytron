package editor

class Person {

    static constraints = {
        name blank: false
        service nullable: true, blank: true
    }

    String name
    TElement service

    @Override
    String toString() {
        return name
    }

    boolean equals(o) {
        if (this.is(o)) return true
        if (!(o instanceof Person)) return false

        Person person = (Person) o

        if (id != person.id) return false

        return true
    }

    int hashCode() {
        return id.hashCode()
    }
}
