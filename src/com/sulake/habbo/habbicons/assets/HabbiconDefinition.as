package com.sulake.habbo.habbicons.assets
{
    public class HabbiconDefinition
    {
        public var previewWidth:int;
        public var previewHeight:int;
        public var direction:int;
        public var animated:Boolean;
        public var loop:Boolean;
        public var frames:Array;
        public var steps:Array;

        public function HabbiconDefinition(previewWidth:int, previewHeight:int, direction:int, animated:Boolean, loop:Boolean, frames:Array, steps:Array)
        {
            this.previewWidth = previewWidth;
            this.previewHeight = previewHeight;
            this.direction = direction;
            this.animated = animated;
            this.loop = loop;
            this.frames = frames;
            this.steps = steps;
        }
    }
}
