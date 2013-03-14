<%@ page import="editor.Article" %>



<div class="fieldcontain ${hasErrors(bean: articleInstance, field: 'title', 'error')} required">
    <label for="title">
        <g:message code="article.title.label" default="Title"/>
        <span class="required-indicator">*</span>
    </label>
    <g:textField name="title" required="" value="${articleInstance?.title}"/>
</div>

<div class="fieldcontain ${hasErrors(bean: articleInstance, field: 'author', 'error')} required">
    <label for="author">
        <g:message code="article.author.label" default="Author"/>
        <span class="required-indicator">*</span>
    </label>
    <g:select id="author" name="author.id" from="${editor.Person.list()}" optionKey="id" required=""
              value="${articleInstance?.author?.id}" class="many-to-one"/>
</div>

<div class="fieldcontain ${hasErrors(bean: articleInstance, field: 'body', 'error')} ">
    <label for="body">
        <g:message code="article.body.label" default="Body"/>

    </label>
    <g:textArea id="body" name="body" cols="40" rows="5" value="${articleInstance?.body}"/>
    <script type="text/javascript">
        var myCodeMirror = CodeMirror.fromTextArea(document.getElementById('body'), {mode: 'xml',
            theme: "neat",
            extraKeys: {
                "'>'": function (cm) {
                    cm.closeTag(cm, '>');
                },
                "'/'": function (cm) {
                    cm.closeTag(cm, '/');
                }
            }});
    </script>
</div>

<div class="fieldcontain ${hasErrors(bean: articleInstance, field: 'createdDate', 'error')} required">
    <label for="createdDate">
        <g:message code="article.createdDate.label" default="Created Date"/>
        <span class="required-indicator">*</span>
    </label>
    <g:datePicker name="createdDate" precision="day" value="${articleInstance?.createdDate}"/>
</div>

<div id="editor">

</div>
<script src="http://d1n0x3qji82z53.cloudfront.net/src-min-noconflict/ace.js" type="text/javascript"
        charset="utf-8"></script>
<script>
    var editor = ace.edit("editor");
    editor.setTheme("ace/theme/monokai");
    editor.getSession().setMode("ace/mode/xml");
</script>