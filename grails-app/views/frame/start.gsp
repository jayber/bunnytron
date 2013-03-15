<html>
<head>
    <title>Xopus Save Example</title>
    <link rel="stylesheet" type="text/css" href="/xopus/examples/simple/css/wysiwyg.css"/>

    <!-- Start Xopus -->
    <script type="text/javascript" src="/xopus/xopus/xopus.js"></script>
</head>

<body>image
<!-- The Xopus Canvas -->
<div xopus="true" autostart="true">
    <xml>
        <x:config version="1.0" xmlns:x="http://www.xopus.com/xmlns/config">
            <!-- Register the save.js script. -->
            <x:javascript src="/xopus/config/save.js"/>

            <x:pipeline xml="/ws/article/${params.id}/body/" xsd="/uk.practicallaw.com.xsd">
                <x:view name="WYSIWYG View">
                    <x:transform xsl="/xopus/examples/howto/SaveToJSP/stylesheet.xsl"/>
                </x:view>
                <x:view name="XML View">
                    <x:treeTransform/>
                </x:view>
            </x:pipeline>
        </x:config>
    </xml>
</div>

</body>
</html>