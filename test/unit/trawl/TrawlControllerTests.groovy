package trawl

import grails.test.mixin.Mock
import grails.test.mixin.TestFor

@TestFor(TrawlController)
@Mock(Trawl)
class TrawlControllerTests {

    def populateValidParams(params) {
        assert params != null
        // TODO: Populate valid properties like...
        //params["name"] = 'someValidName'
    }

    void testIndex() {
        controller.index()
        assert "/trawl/list" == response.redirectedUrl
    }

    void testList() {

        def model = controller.list()

        assert model.trawlInstanceList.size() == 0
        assert model.trawlInstanceTotal == 0
    }

    void testCreate() {
        def model = controller.create()

        assert model.trawlInstance != null
    }

    void testSave() {
        controller.save()

        assert model.trawlInstance != null
        assert view == '/trawl/create'

        response.reset()

        populateValidParams(params)
        controller.save()

        assert response.redirectedUrl == '/trawl/show/1'
        assert controller.flash.message != null
        assert Trawl.count() == 1
    }

    void testShow() {
        controller.show()

        assert flash.message != null
        assert response.redirectedUrl == '/trawl/list'

        populateValidParams(params)
        def trawl = new Trawl(params)

        assert trawl.save() != null

        params.id = trawl.id

        def model = controller.show()

        assert model.trawlInstance == trawl
    }

    void testEdit() {
        controller.edit()

        assert flash.message != null
        assert response.redirectedUrl == '/trawl/list'

        populateValidParams(params)
        def trawl = new Trawl(params)

        assert trawl.save() != null

        params.id = trawl.id

        def model = controller.edit()

        assert model.trawlInstance == trawl
    }

    void testUpdate() {
        controller.update()

        assert flash.message != null
        assert response.redirectedUrl == '/trawl/list'

        response.reset()

        populateValidParams(params)
        def trawl = new Trawl(params)

        assert trawl.save() != null

        // test invalid parameters in update
        params.id = trawl.id
        //TODO: add invalid values to params object

        controller.update()

        assert view == "/trawl/edit"
        assert model.trawlInstance != null

        trawl.clearErrors()

        populateValidParams(params)
        controller.update()

        assert response.redirectedUrl == "/trawl/show/$trawl.id"
        assert flash.message != null

        //test outdated version number
        response.reset()
        trawl.clearErrors()

        populateValidParams(params)
        params.id = trawl.id
        params.version = -1
        controller.update()

        assert view == "/trawl/edit"
        assert model.trawlInstance != null
        assert model.trawlInstance.errors.getFieldError('version')
        assert flash.message != null
    }

    void testDelete() {
        controller.delete()
        assert flash.message != null
        assert response.redirectedUrl == '/trawl/list'

        response.reset()

        populateValidParams(params)
        def trawl = new Trawl(params)

        assert trawl.save() != null
        assert Trawl.count() == 1

        params.id = trawl.id

        controller.delete()

        assert Trawl.count() == 0
        assert Trawl.get(trawl.id) == null
        assert response.redirectedUrl == '/trawl/list'
    }
}
