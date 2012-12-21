package editor

import grails.test.mixin.Mock
import grails.test.mixin.TestFor

@TestFor(TElementController)
@Mock(TElement)
class TElementControllerTests {

    def populateValidParams(params) {
        assert params != null
        // TODO: Populate valid properties like...
        //params["name"] = 'someValidName'
    }

    void testIndex() {
        controller.index()
        assert "/TElement/list" == response.redirectedUrl
    }

    void testList() {

        def model = controller.list()

        assert model.TElementInstanceList.size() == 0
        assert model.TElementInstanceTotal == 0
    }

    void testCreate() {
        def model = controller.create()

        assert model.TElementInstance != null
    }

    void testSave() {
        controller.save()

        assert model.TElementInstance != null
        assert view == '/TElement/create'

        response.reset()

        populateValidParams(params)
        controller.save()

        assert response.redirectedUrl == '/TElement/show/1'
        assert controller.flash.message != null
        assert TElement.count() == 1
    }

    void testShow() {
        controller.show()

        assert flash.message != null
        assert response.redirectedUrl == '/TElement/list'

        populateValidParams(params)
        def TElement = new TElement(params)

        assert TElement.save() != null

        params.id = TElement.id

        def model = controller.show()

        assert model.TElementInstance == TElement
    }

    void testEdit() {
        controller.edit()

        assert flash.message != null
        assert response.redirectedUrl == '/TElement/list'

        populateValidParams(params)
        def TElement = new TElement(params)

        assert TElement.save() != null

        params.id = TElement.id

        def model = controller.edit()

        assert model.TElementInstance == TElement
    }

    void testUpdate() {
        controller.update()

        assert flash.message != null
        assert response.redirectedUrl == '/TElement/list'

        response.reset()

        populateValidParams(params)
        def TElement = new TElement(params)

        assert TElement.save() != null

        // test invalid parameters in update
        params.id = TElement.id
        //TODO: add invalid values to params object

        controller.update()

        assert view == "/TElement/edit"
        assert model.TElementInstance != null

        TElement.clearErrors()

        populateValidParams(params)
        controller.update()

        assert response.redirectedUrl == "/TElement/show/$TElement.id"
        assert flash.message != null

        //test outdated version number
        response.reset()
        TElement.clearErrors()

        populateValidParams(params)
        params.id = TElement.id
        params.version = -1
        controller.update()

        assert view == "/TElement/edit"
        assert model.TElementInstance != null
        assert model.TElementInstance.errors.getFieldError('version')
        assert flash.message != null
    }

    void testDelete() {
        controller.delete()
        assert flash.message != null
        assert response.redirectedUrl == '/TElement/list'

        response.reset()

        populateValidParams(params)
        def TElement = new TElement(params)

        assert TElement.save() != null
        assert TElement.count() == 1

        params.id = TElement.id

        controller.delete()

        assert TElement.count() == 0
        assert TElement.get(TElement.id) == null
        assert response.redirectedUrl == '/TElement/list'
    }
}
