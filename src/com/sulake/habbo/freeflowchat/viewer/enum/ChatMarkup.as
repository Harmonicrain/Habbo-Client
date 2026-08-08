package com.sulake.habbo.freeflowchat.viewer.enum
{
    public class ChatMarkup
    {
        public static const COLOUR_ARRAY:Array = [["red", 9115929], ["cyan", 32639], ["blue", 19609], ["green", 32768], ["purple", 4980812]];
        private static const WHITE_TEXT_COLOUR_ARRAY:Array = [["red", 16738922], ["cyan", 5233370], ["blue", 6269183], ["green", 6738794], ["purple", 11767039]];
        public static const COLOUR_NAMES:Array = (function():Array
        {
            var names:Array = [];
            var entry:Array;
            for each (entry in COLOUR_ARRAY)
            {
                names.push(entry[0]);
            }
            return names;
        })();

        public function ChatMarkup()
        {
            super();
        }

        private static function getColourArray(baseColour:uint):Array
        {
            return baseColour == 0xFFFFFF ? WHITE_TEXT_COLOUR_ARRAY : COLOUR_ARRAY;
        }

        private static function getHexColorForTag(tag:String, baseColour:uint):String
        {
            var entry:Array;
            for each (entry in getColourArray(baseColour))
            {
                if (entry[0] == tag)
                {
                    return "#" + entry[1].toString(16).toUpperCase();
                }
            }
            return null;
        }

        public static function applyColourToChat(text:String, baseColour:uint):String
        {
            var entry:Array;
            var hex:String;
            var body:String;
            for each (entry in getColourArray(baseColour))
            {
                if (text.indexOf("@" + entry[0] + "@") == 0)
                {
                    hex = "#" + entry[1].toString(16).toUpperCase();
                    body = text.substring(entry[0].length + 2, text.length);
                    if (body.charAt(0) == " ")
                    {
                        body = body.substr(1);
                    }
                    return "<font color=\"" + hex + "\">" + body + "</font>";
                }
            }
            return text;
        }

        public static function tokenize(text:String):Array
        {
            var result:Array = [];
            var token:String = "";
            var insideTag:Boolean = false;
            var i:int;
            var ch:String;
            for (i = 0; i < text.length; i++)
            {
                ch = text.charAt(i);
                if (ch == "[")
                {
                    if (token.length > 0)
                    {
                        result.push(token);
                        token = "";
                    }
                    insideTag = true;
                    token += ch;
                }
                else if (((ch == "]") && (insideTag)))
                {
                    token += ch;
                    result.push(token);
                    token = "";
                    insideTag = false;
                }
                else
                {
                    token += ch;
                }
            }
            if (token.length > 0)
            {
                result.push(token);
            }
            return result;
        }

        public static function applyToElements(text:String, baseColour:uint):String
        {
            var i:int;
            var token:String;
            var tag:String;
            var closing:Boolean;
            var open:Object;
            var hex:String;
            if (text.length == 0)
            {
                return "";
            }
            var tokens:Array = tokenize(text);
            var stack:Array = [];
            for (i = 0; i < tokens.length; i++)
            {
                token = tokens[i];
                if (((token.charAt(0) == "[") && (token.charAt(token.length - 1) == "]") && ((token.charAt(1) == "/") || ((token.length > 2) && (token.length <= 10)))))
                {
                    tag = token.substring(1, token.length - 1).toLowerCase();
                    closing = tag.charAt(0) == "/";
                    if (closing)
                    {
                        tag = tag.substr(1);
                        if (((stack.length > 0) && (stack[(stack.length - 1)].tag == tag)))
                        {
                            open = stack.pop();
                            if ((((tag == "b") || (tag == "i")) || (tag == "u")))
                            {
                                tokens[open.index] = "<" + tag + ">";
                                tokens[i] = "</" + tag + ">";
                            }
                            else
                            {
                                hex = getHexColorForTag(tag, baseColour);
                                if (hex != null)
                                {
                                    tokens[open.index] = "<font color=\"" + hex + "\">";
                                    tokens[i] = "</font>";
                                }
                            }
                        }
                    }
                    else if (((((tag == "b") || (tag == "i")) || (tag == "u")) || (COLOUR_NAMES.indexOf(tag) != -1)))
                    {
                        stack.push({tag:tag, index:i});
                    }
                }
            }
            return tokens.join("");
        }
    }
}
