
<cfcomponent name="Currency" hint="A utility for Currency Converter" output="false">
    
    <cffunction name="init" access="public" returntype="Currency" hint="Constructor" output="false">
    <cfargument name="converter" type="string" required="true">
        <cfset local = structnew()>
        <cfset this.converter = arguments.converter>
        <cfreturn this>
	</cffunction>
    
    <cffunction name="convert" access="public" returntype="Struct">
    <cfargument name="conversion" type="struct" required="true">
		<cfif trim(conversion.country) eq trim(conversion.convert_country) >
			<cfset conversion.convert_amount = conversion.amount>
			<cfset conversion.status = true>
        <cfelse>
            <cfset theMethod = getMethod(this.converter)>
            <cfset conversion = theMethod(arguments.conversion)>
        </cfif>
        <cfreturn conversion>
	</cffunction>
    
    <cffunction name="getMethod" access="private" returntype="any">
    <cfargument name="method" type="string" required="true">
        <cfreturn variables[arguments.method]>
	</cffunction>
    
    <cffunction name="google" access="private" returntype="Struct">
    <cfargument name="conversion" type="struct" required="true">
        <cfhttp url="https://www.google.com/finance/converter" method="get" >
            <cfhttpparam name="a" type="url" value="#arguments.conversion.amount#">
            <cfhttpparam name="from" type="url" value="#arguments.conversion.country#">
            <cfhttpparam name="to" type="url" value="#arguments.conversion.convert_country#">
        </cfhttp>
        <cfset parseResult = cfhttp.Filecontent >
        <cfset valuePos = findnocase('<span class=bld>',parseResult) >
        <cfset valuePosLast = findnocase('</span>',parseResult) >
        <cfset reqCount = valuePosLast - valuePos >
        <cfif valuePos>
            <cfset parseResult = Mid(cfhttp.Filecontent, valuePos, reqCount) >
            <cfset parseResult = rereplace(replace(parseResult,'<span class=bld>','','ALL'),'<|>|/|\\','','ALL') >
            <cfset conversion.convert_amount = listtoarray(parseResult," ")[1] >
            <cfset conversion.convert_country = listtoarray(parseResult," ")[2]  >
            <cfset conversion.status = true  >
        </cfif>
        <cfreturn conversion>
	</cffunction>
    
    <cffunction name="xe" access="private" returntype="Struct">
    <cfargument name="conversion" type="struct" required="true">
        <cfhttp method="get" url="https://xecdapi.xe.com/v1/convert_to.json" username="wb21(us)inc.975615761" password="k6964bkdbar46d3i7q998cqoqt" result="hello">
            <cfhttpparam name="to" type="url" value="#arguments.conversion.country#">
            <cfhttpparam name="from" type="url" value="#arguments.conversion.convert_country#">
            <cfhttpparam name="amount" type="url" value="#arguments.conversion.amount#">
        </cfhttp>
        <cfset parseResult = DeserializeJson(hello.Filecontent)>
        <!--- <cfset parseResult = DeserializeJson('{"terms":"http://www.xe.com/legal/dfs.php","privacy":"http://www.xe.com/privacy.php","to":"CAD","amount":1000.0,"timestamp":"2016-06-29T14:14:00Z","from":[{"quotecurrency":"USD","mid":769.1894485117}]}')> --->
            
        <cfif StructKeyExists(parseResult, "from")>
            <cfset from = parseResult.from>
            <cfif ArrayLen(from) gt 0>
                <cfset conversion.convert_amount = from[1].mid>
                <cfset conversion.convert_country = from[1].quotecurrency>
                <cfset conversion.status = true>
            </cfif>            
        </cfif>
        <cfreturn conversion>
	</cffunction>
    
    <cffunction name="yahoo" access="private" returntype="Struct">
    <cfargument name="conversion" type="struct" required="true">
        <cfhttp url="https://query.yahooapis.com/v1/public/yql" method="get" >
            <cfhttpparam name="q" type="url" value="select * from yahoo.finance.xchange where pair in ('#arguments.conversion.country##arguments.conversion.convert_country#')">
            <cfhttpparam name="format" type="url" value="json">
            <cfhttpparam name="env" type="url" value="store://datatables.org/alltableswithkeys">
        </cfhttp>
        <cfset parseResult = DeserializeJson(cfhttp.Filecontent)>
        <cfset conversion.convert_amount = arguments.conversion.amount * parseResult.query.results.rate.Rate>
        <cfset conversion.status = true>
        <cfreturn conversion>
	</cffunction>
    
    <cffunction name="xignite" access="private" returntype="Struct">
    <cfargument name="conversion" type="struct" required="true">
        <cfhttp url="http://globalcurrencies.xignite.com/xGlobalCurrencies.json/ConvertRealTimeValue" method="get" >
            <cfhttpparam name="From" type="url" value="#arguments.conversion.country#">
            <cfhttpparam name="To" type="url" value="#arguments.conversion.convert_country#">
            <cfhttpparam name="Amount" type="url" value="#arguments.conversion.amount#">
            <cfhttpparam name="_token" type="url" value="45BDBBB1E8D44C13B75D2D8FCDFC5A3E">
        </cfhttp>
        <cfset parseResult = DeserializeJson(cfhttp.Filecontent)>
        <cfset conversion.convert_amount = arguments.conversion.amount * parseResult.Rate>
        <cfset conversion.status = true>
        <cfreturn conversion>
    </cffunction>
    
</cfcomponent>