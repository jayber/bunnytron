<%@ page import="editor.Article" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <g:set var="entityName" value="${message(code: 'article.label', default: 'Article')}"/>
    <title><g:message code="default.show.label" args="[entityName]"/></title>
</head>

<body>
<a href="#show-article" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>

<div class="nav" role="navigation">
    <ul>
        <li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>
        <li><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]"/></g:link></li>
        <li><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]"/></g:link></li>
    </ul>
</div>

<div id="show-article" class="content scaffold-show" role="main">
    <h1><g:message code="default.show.label" args="[entityName]"/></h1>
    <g:if test="${flash.message}">
        <div class="message" role="status">${flash.message}</div>
    </g:if>
    <ol class="property-list article">

        <g:if test="${articleInstance?.title}">
            <li class="fieldcontain">
                <span id="title-label" class="property-label"><g:message code="article.title.label" default="Title"/></span>

                <span class="property-value" aria-labelledby="title-label"><g:fieldValue bean="${articleInstance}" field="title"/></span>

            </li>
        </g:if>

        <g:if test="${articleInstance?.author}">
            <li class="fieldcontain">
                <span id="author-label" class="property-label"><g:message code="article.author.label" default="Author"/></span>

                <span class="property-value" aria-labelledby="author-label"><g:link controller="person" action="show" id="${articleInstance?.author?.id}">${articleInstance?.author?.encodeAsHTML()}</g:link></span>

            </li>
        </g:if>

        <g:if test="${articleInstance?.body}">
            <li class="fieldcontain">
                <span id="body-label" class="property-label"><g:message code="article.body.label" default="Body"/></span>

                <span class="property-value" aria-labelledby="body-label"><g:fieldValue bean="${articleInstance}" field="body"/></span>

            </li>
        </g:if>

        <g:if test="${articleInstance?.service}">
            <li class="fieldcontain">
                <span id="service-label" class="property-label"><g:message code="article.service.label" default="Service"/></span>

                <span class="property-value" aria-labelledby="service-label"><g:link controller="TElement" action="show" id="${articleInstance?.service?.id}">${articleInstance?.service?.encodeAsHTML()}</g:link></span>

            </li>
        </g:if>

        <g:if test="${articleInstance?.maintained}">
            <li class="fieldcontain">
                <span id="maintained-label" class="property-label"><g:message code="article.maintained.label" default="Maintained"/></span>

                <span class="property-value" aria-labelledby="maintained-label"><g:formatBoolean boolean="${articleInstance?.maintained}"/></span>

            </li>
        </g:if>

        <g:if test="${articleInstance?.maintainDate}">
            <li class="fieldcontain">
                <span id="maintainDate-label" class="property-label"><g:message code="article.maintainDate.label" default="Maintain Date"/></span>

                <span class="property-value" aria-labelledby="maintainDate-label"><g:formatDate date="${articleInstance?.maintainDate}"/></span>

            </li>
        </g:if>

        <g:if test="${articleInstance?.createdDate}">
            <li class="fieldcontain">
                <span id="createdDate-label" class="property-label"><g:message code="article.createdDate.label" default="Created Date"/></span>

                <span class="property-value" aria-labelledby="createdDate-label"><g:formatDate date="${articleInstance?.createdDate}"/></span>

            </li>
        </g:if>

    </ol>
    <g:form>
        <fieldset class="buttons">
            <g:hiddenField name="id" value="${articleInstance?.id}"/>
            <g:link class="edit" action="edit" id="${articleInstance?.id}"><g:message code="default.button.edit.label" default="Edit"/></g:link>
            <g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');"/>
        </fieldset>
    </g:form>
</div>
</body>
</html>
