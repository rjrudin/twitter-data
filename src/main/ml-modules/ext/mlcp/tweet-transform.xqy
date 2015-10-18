xquery version "1.0-ml";

module namespace transform = "urn:sample:transform";

(:
This transform is used to clean the data up a bit - specifically, there are a lot of parent/child
sets where the parent/kids have the same name, so we change those to have plural/singular names
:)
declare function transform(
  $content as map:map,
  $context as map:map
  ) as map:map*
{
	let $tweet := map:get($content, "value")/marklogic
	let $_ := map:put($content, "value", rewrite($tweet))
	return $content
};

declare private function rewrite($el as element()) as element()
{
	let $name := local-name($el)
	let $name := 
		if ($name = "urls" and $el/parent::urls) then "url"
		else if ($name = "indices" and $el/parent::indices) then "index"
		else if ($name = "links" and $el/parent::links) then "link"
		else if ($name = "user_mentions" and $el/parent::user_mentions) then "user_mention"
		else if ($name = "hashtags" and $el/parent::hashtags) then "hashtag"
		else $name
	return element {$name} {
		$el/@*,
		for $kid in $el/node()
		return
			if (xdmp:node-kind($kid) = "text") then $kid
			else rewrite($kid)
	}
};