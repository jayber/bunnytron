package taxonomy

import grails.test.mixin.Mock
import grails.test.mixin.TestFor

@TestFor(SubjectAreaController)
@Mock(SubjectArea)
class SubjectAreaControllerTests {

    def populateValidParams(params) {
        assert params != null
        // TODO: Populate valid properties like...
        //params["name"] = 'someValidName'
    }

    void testIndex() {
        controller.index()
        assert "/subjectArea/list" == response.redirectedUrl
    }

    void testList() {

        def model = controller.list()

        assert model.subjectAreaInstanceList.size() == 0
        assert model.subjectAreaInstanceTotal == 0
    }

    void testCreate() {
        def model = controller.create()

        assert model.subjectAreaInstance != null
    }

    void testSave() {
        controller.save()

        assert model.subjectAreaInstance != null
        assert view == '/subjectArea/create'

        response.reset()

        populateValidParams(params)
        controller.save()

        assert response.redirectedUrl == '/subjectArea/show/1'
        assert controller.flash.message != null
        assert SubjectArea.count() == 1
    }

    void testShow() {
        controller.show()

        assert flash.message != null
        assert response.redirectedUrl == '/subjectArea/list'

        populateValidParams(params)
        def subjectArea = new SubjectArea(params)

        assert subjectArea.save() != null

        params.id = subjectArea.id

        def model = controller.show()

        assert model.subjectAreaInstance == subjectArea
    }

    void testEdit() {
        controller.edit()

        assert flash.message != null
        assert response.redirectedUrl == '/subjectArea/list'

        populateValidParams(params)
        def subjectArea = new SubjectArea(params)

        assert subjectArea.save() != null

        params.id = subjectArea.id

        def model = controller.edit()

        assert model.subjectAreaInstance == subjectArea
    }

    void testUpdate() {
        controller.update()

        assert flash.message != null
        assert response.redirectedUrl == '/subjectArea/list'

        response.reset()

        populateValidParams(params)
        def subjectArea = new SubjectArea(params)

        assert subjectArea.save() != null

        // test invalid parameters in update
        params.id = subjectArea.id
        //TODO: add invalid values to params object

        controller.update()

        assert view == "/subjectArea/edit"
        assert model.subjectAreaInstance != null

        subjectArea.clearErrors()

        populateValidParams(params)
        controller.update()

        assert response.redirectedUrl == "/subjectArea/show/$subjectArea.id"
        assert flash.message != null

        //test outdated version number
        response.reset()
        subjectArea.clearErrors()

        populateValidParams(params)
        params.id = subjectArea.id
        params.version = -1
        controller.update()

        assert view == "/subjectArea/edit"
        assert model.subjectAreaInstance != null
        assert model.subjectAreaInstance.errors.getFieldError('version')
        assert flash.message != null
    }

    void testDelete() {
        controller.delete()
        assert flash.message != null
        assert response.redirectedUrl == '/subjectArea/list'

        response.reset()

        populateValidParams(params)
        def subjectArea = new SubjectArea(params)

        assert subjectArea.save() != null
        assert SubjectArea.count() == 1

        params.id = subjectArea.id

        controller.delete()

        assert SubjectArea.count() == 0
        assert SubjectArea.get(subjectArea.id) == null
        assert response.redirectedUrl == '/subjectArea/list'
    }
}
