<!DOCTYPE html>
<html>
<head>
    <title>editor</title>
    <meta name="ROBOTS" content="NOINDEX">
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="">
    <script src="/xopus/xopus/xopus.js"></script>
</head>

<div xopus="true">
    Starting Xopus...
    <xml>
        <config version="1.0" xmlns="http://www.xopus.com/xmlns/config">
            %{--/article/${params.id}/body/--}%
            <pipeline xsd="/doctypes/plc/plc.xsd">
                <view name="WYSIWYG View">
                    <transform xsl="/xsl/plcdtd/plcdtd2html.xsl"/>
                </view>
            </pipeline>
        </config>
    </xml>
</div>

</html>