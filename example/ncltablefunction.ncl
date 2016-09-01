<?xml version="1.0" encoding="ISO-8859-1"?>
<!-- Exemplo de navegacao por teclas -->
<ncl id="menuEx" xmlns="http://www.ncl.org.br/NCL3.0/EDTVProfile">
	<head>
		<ruleBase>
			<rule id="en" var="system.language" value="en" comparator="eq"/>
<!-- 			<rule id="int" var="service.interactivity" value="true" comparator="eq"/> -->
			<rule id="rRock" var="service.currentFocus" value="3" comparator="eq"/>
			<rule id="rTechno" var="service.currentFocus" value="4" comparator="eq"/>
			<rule id="rCartoon" var="service.currentFocus" value="5" comparator="eq"/>
		</ruleBase>
		<transitionBase>
			<transition id="trans1" type="fade" dur="2s"/>
			<transition id="trans2" type="barWipe" dur="1s"/>
		</transitionBase>
		
		<connectorBase>
			<importBase documentURI="causalConnBase.ncl" alias="conEx"/>
		</connectorBase>
	</head>

	<body>
		<port id="entry" component="animation"/>
		<media id="background" src="media/background.png" />
		<media id="animation" src="media/animGar.mp4" >
		</media>
		
		<context id="menu">
			<port id="pChoro" component="choro"/>
			<port id="pChorinho" component="imgChorinho"/>
			<port id="pRock" component="imgRock"/>
			<port id="pTechno" component="imgTechno"/>
			<port id="pCartoon" component="imgCartoon"/>
			<media id="imgChorinho" src="media/chorinho.png" class="menu"/>
			<media id="imgRock" src="media/rock.png" class="menu"/>
			<media id="imgTechno" src="media/techno.png" class="menu"/>
			<media id="imgCartoon" src="media/cartoon.png" class="menu"/>
			
			<link id="lChoro" xconnector="conEx#onSelectionSet_varStop">
				<bind role="onSelection" component="imgChorinho"/>
				<bind role="set" component="choro" interface="soundLevel">
					<bindParam name="var" value="1"/>
				</bind>
				<bind role="stop" component="musics"/>
			</link>
			<link id="lOthers" xconnector="conEx#onSelection_orSet_varStopStart">
				<bind role="onSelection" component="imgRock"/>
				<bind role="onSelection" component="imgTechno"/>
				<bind role="onSelection" component="imgCartoon"/>
				<bind role="set" component="choro" interface="soundLevel">
					<bindParam name="var" value="0"/>
				</bind>
				<bind role="stop" component="musics"/>
				<bind role="start" component="musics"/>
			</link>
		</context>
		<link  id="lMusic" xconnector="conEx#onBeginStart_delay">
			<bind role="onBegin" component="animation"/>
			<bind role="start" component="background">
				<bindParam name="delay" value="5s"/>
			</bind>
			<bind role="start" component="menu">
				<bindParam name="delay" value="5s"/>
			</bind>
		</link>
		<link  id="lEnd" xconnector="conEx#onEndStop">
			<bind role="onEnd" component="animation"/>
			<bind role="stop" component="background"/>
			<!--bind role="stop" component="interactivity"/-->
		</link>	
	</body>
</ncl>
