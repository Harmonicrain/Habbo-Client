package com.sulake.habbo.roomevents.wired_setup.selectors
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.NeighborhoodFloor;
    import com.sulake.habbo.roomevents.wired_setup.common.utils.SpiralUtils;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.WiredInputSourcePicker;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.AssetButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.NumberInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.AssetButtonPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.AssetButtonRowPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SectionPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SimpleListViewPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.applications.FloorDrawingPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.applications.FloorEditorPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.combinations.NamedNumberInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import flash.geom.Point;

    /** Shared May 2026 neighbourhood editor for furni and user selectors. */
    public class InNeighborhoodSelectorElement extends DefaultElement
    {
        private static const DRAW_MODES:Array = ["add_tile", "remove_tile", "set_root_tile"];

        private var _drawMode:String = DRAW_MODES[0];
        private var _rootTile:Point;
        private var _floor:NeighborhoodFloor;
        private var _useUserSource:Boolean;
        private var _floorEditorPreset:FloorEditorPreset;
        private var _floorDrawingPreset:FloorDrawingPreset;
        private var _rootXInput:NamedNumberInputPreset;
        private var _rootYInput:NamedNumberInputPreset;
        private var _drawButtonsByMode:Object;
        private var _preferBigMode:Boolean;
        private var _inBigMode:Boolean;
        private var _resolutionButton:AssetButtonPreset;

        override public function get inputMode():int
        {
            return INPUTS_TYPE_UI_BUILDER;
        }

        override public function onInit(roomEvents:HabboUserDefinedRoomEvents):void
        {
            super.onInit(roomEvents);
            this.setRootTileInternal(0, 0, false);
            this._floor = new NeighborhoodFloor(
                SpiralUtils.parseSpiralVector([], NeighborhoodFloor.RADIUS),
                !this._preferBigMode,
                this.onDrawingChanged);
        }

        override public function onEditStart(triggerable:Triggerable):void
        {
            this._inBigMode = this._preferBigMode;
            this._useUserSource = triggerable.intData.length > 0 && triggerable.intData[0] != 0;
            this.setRootTileInternal(
                triggerable.intData.length > 1 ? triggerable.intData[1] : 0,
                triggerable.intData.length > 2 ? triggerable.intData[2] : 0,
                true);
            this.setMode(DRAW_MODES[0]);
            this._floor = new NeighborhoodFloor(
                SpiralUtils.parseSpiralVector(triggerable.intData.slice(3), NeighborhoodFloor.RADIUS),
                !this._inBigMode,
                this.onDrawingChanged);
            if (!this._inBigMode && !this._floor.smallModeAllowed())
            {
                this._floor.smallMode = false;
                this._inBigMode = true;
            }
            if (this._floorDrawingPreset != null)
            {
                this._floorDrawingPreset.setFloor(this._floor);
                this._floorDrawingPreset.setRootTile(int(this._rootTile.x), int(this._rootTile.y));
                this._floorDrawingPreset.setMode(this._drawMode);
            }
            this.updateResolutionButtonUI();
            this.roomEvents.wiredCtrl.resizeFrame();
        }

        override public function readIntParamsFromForm():Array
        {
            var result:Array = [this._useUserSource ? 1 : 0, int(this._rootTile.x), int(this._rootTile.y)];
            return result.concat(SpiralUtils.createSpiralVector(this._floor.floorPlanCache, NeighborhoodFloor.RADIUS));
        }

        override public function mergedSelections():Array
        {
            return [[0, 0]];
        }

        override public function mergedSelectionTitle(index:int):String
        {
            return "wiredfurni.params.sources.merged.title.neighborhood";
        }

        override public function setMergedType(index:int, sourceType:int):void
        {
            this._useUserSource = sourceType == WiredInputSourcePicker.USER_SOURCE;
        }

        override public function getMergedType(index:int):int
        {
            return this._useUserSource ? WiredInputSourcePicker.USER_SOURCE : WiredInputSourcePicker.FURNI_SOURCE;
        }

        override public function get forceHidePickFurniInstructions():Boolean
        {
            return true;
        }

        override public function advancedAlwaysVisible():Boolean
        {
            return true;
        }

        override public function buildInputs(presets:PresetManager, style:WiredStyle, builder:WiredUIBuilder):void
        {
            var buttonConfigs:Array = [
                new AssetButtonParam("add", "", function():void { setMode(DRAW_MODES[0]); }),
                new AssetButtonParam("remove", "", function():void { setMode(DRAW_MODES[1]); }, true),
                new AssetButtonParam("reference", "", function():void { setMode(DRAW_MODES[2]); }),
                new AssetButtonParam("enlarge_image", "", this.toggleScreenSize, false, true)
            ];
            var buttonRow:AssetButtonRowPreset = presets.createAssetButtonRow(buttonConfigs);
            this._floorDrawingPreset = presets.createFloorDrawingPreset(this.onRootTileChangedFromPreset);
            this._floorEditorPreset = presets.createFloorEditorPreset(buttonRow, this._floorDrawingPreset);
            this._resolutionButton = buttonRow.buttons[3];
            if (this._floor != null)
            {
                this._floorDrawingPreset.setFloor(this._floor);
                this._floorDrawingPreset.setRootTile(int(this._rootTile.x), int(this._rootTile.y));
                this._floorDrawingPreset.setMode(this._drawMode);
            }

            this._rootXInput = presets.createNamedNumberInput(new NumberInputParam(0, -64, 64, 20), "x:");
            this._rootYInput = presets.createNamedNumberInput(new NumberInputParam(0, -64, 64, 20), "y:");
            this._rootXInput.onValueChange = this.onRootXChanged;
            this._rootYInput.onValueChange = this.onRootYChanged;
            var xyRow:SimpleListViewPreset = presets.createSimpleListView(false, [this._rootXInput, this._rootYInput]);
            xyRow.spacing = style.genericHorizontalSpacing;

            this._drawButtonsByMode = {};
            var createdButtons:Vector.<AssetButtonPreset> = buttonRow.buttons;
            for (var i:int = 0; i < DRAW_MODES.length && i < createdButtons.length; i++)
            {
                this._drawButtonsByMode[DRAW_MODES[i]] = createdButtons[i];
            }
            this.setMode(this._drawMode);

            var list:SimpleListViewPreset = presets.createSimpleListView(true, [this._floorEditorPreset, xyRow.alignRight()]);
            var section:SectionPreset = presets.createSection(l("neighborhood_selection"), list);
            builder.addElements(section);
        }

        override public function get widthModifier():Number
        {
            return this._inBigMode ? 1.7 : 1;
        }

        private function setMode(mode:String):void
        {
            this._drawMode = mode;
            if (this._floorDrawingPreset != null)
            {
                this._floorDrawingPreset.setMode(mode);
            }
            if (this._drawButtonsByMode == null)
            {
                return;
            }
            for each (var drawMode:String in DRAW_MODES)
            {
                var button:AssetButtonPreset = this._drawButtonsByMode[drawMode] as AssetButtonPreset;
                if (button != null)
                {
                    button.selected = drawMode == mode;
                }
            }
        }

        private function updateResolutionButtonUI():void
        {
            if (this._resolutionButton == null || this._floor == null)
            {
                return;
            }
            this._resolutionButton.disabled = !this._floor.smallModeAllowed();
            this._resolutionButton.assetName = this._inBigMode ? "reduce_image" : "enlarge_image";
        }

        private function updateRootInputText():void
        {
            if (this._rootXInput != null)
            {
                this._rootXInput.value = int(this._rootTile.x);
            }
            if (this._rootYInput != null)
            {
                this._rootYInput.value = int(this._rootTile.y);
            }
        }

        private function setRootTileInternal(x:int, y:int, updateDrawing:Boolean):void
        {
            if (this._rootTile == null)
            {
                this._rootTile = new Point(x, y);
            }
            else
            {
                this._rootTile.x = x;
                this._rootTile.y = y;
            }
            this.updateRootInputText();
            if (updateDrawing && this._floorDrawingPreset != null)
            {
                this._floorDrawingPreset.setRootTile(x, y);
            }
        }

        private function onRootXChanged(value:int):void
        {
            this.setRootTileInternal(value, int(this._rootTile.y), true);
        }

        private function onRootYChanged(value:int):void
        {
            this.setRootTileInternal(int(this._rootTile.x), value, true);
        }

        private function onRootTileChangedFromPreset(x:int, y:int):void
        {
            this.setRootTileInternal(x, y, false);
        }

        private function toggleScreenSize():void
        {
            if (this._floor == null || this._floorDrawingPreset == null)
            {
                return;
            }
            this._inBigMode = !this._inBigMode;
            this._preferBigMode = this._inBigMode;
            this._floor.smallMode = !this._inBigMode;
            this._floorDrawingPreset.setFloor(this._floor);
            this.updateResolutionButtonUI();
            this.roomEvents.wiredCtrl.resizeFrame();
        }

        private function onDrawingChanged():void
        {
            this.updateResolutionButtonUI();
        }
    }
}
