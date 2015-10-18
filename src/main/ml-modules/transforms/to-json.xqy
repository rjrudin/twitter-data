xquery version "1.0-ml";

module namespace transform = "http://marklogic.com/rest-api/transform/xto-json";

import module namespace json="http://marklogic.com/xdmp/json" at "/MarkLogic/json/json.xqy";

declare namespace jb = "http://marklogic.com/xdmp/json/basic";

declare variable $ARRAY-ELEMENT-NAMES := ("urls", "indices", "user_mentions", "hashtags");

(:
Example of a transform for /v1/documents that converts XML into MarkLogic's "basic JSON"
XML format, which MarkLogic knows how to convert into correct JSON. Some helper functions
are used to build the JSON XML.
:)
declare function transform(
  $context as map:map,
  $params as map:map,
  $content as document-node()
  ) as document-node()
{
	let $tweet := $content/marklogic
	return document {
		json:transform-to-json(
			<jb:json type="object">
			{
				to-string($tweet/id),
				to-string($tweet/body),
				to-string($tweet/link),
				to-object($tweet/provider),
				to-object($tweet/object),
				to-object($tweet/actor),
				to-object($tweet/twitter_entities)
			}
			</jb:json>
		)
	}
};

declare private function to-string($element as element()) as element()
{
	element {build-safe-qname($element)} {
		attribute type {"string"},
		$element/string()
	}
};

(:
Need to transform the data a bit
:)
declare private function to-array($element as element()) as element()
{
	element {build-safe-qname($element)} {
		attribute type {"array"},
		for $kid in $element/element()
		return
			if (local-name($kid) = $ARRAY-ELEMENT-NAMES) then to-array($kid)
			else if ($kid/text()) then to-string($kid)
			else to-object($kid)
	}	
};

declare private function to-object($element as element()) as element()
{
	element {build-safe-qname($element)} {
		attribute type {"object"},
		for $kid in $element/element()
		return
			if (local-name($kid) = $ARRAY-ELEMENT-NAMES) then to-array($kid)
			else if ($kid/text()) then to-string($kid)
			else to-object($kid)
	}
};

declare private function build-safe-qname($element as element())
{
	fn:QName(
		"http://marklogic.com/xdmp/json/basic",
		let $name := local-name($element)
		return replace($name, "_", "-")
	)
};