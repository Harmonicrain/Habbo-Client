package com.sulake.habbo.roomevents.wired_setup.actiontypes
{
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes.ActionTypeCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.CheckboxOptionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.NumberInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.SectionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.CheckboxGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.NumberInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SectionPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SimpleListViewPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextualButtonPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.combinations.NamedTextInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.combinations.RewardListPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.combinations.RewardRowPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    public class GiveRewardActionElement extends DefaultElement
    {
        private static const MAX_REWARDS:int = 20;
        private static const DEFAULT_REWARDS:int = 5;

        private var _prizeLimitCheckbox:CheckboxGroupPreset;
        private var _prizeLimitInput:NumberInputPreset;
        private var _prizeLimitWarning:TextPreset;
        private var _prizeLimitWarningHeight:int;
        private var _rewardIntervalGroup:RadioGroupPreset;
        private var _rewardIntervalInput:NamedTextInputPreset;
        private var _uniquePrizeCheckbox:CheckboxGroupPreset;
        private var _rewardList:RewardListPreset;
        private var _displayedRewards:int = DEFAULT_REWARDS;

        override public function get code():int
        {
            return ActionTypeCodes.GIVE_REWARD;
        }

        override public function get inputMode():int
        {
            return INPUTS_TYPE_UI_BUILDER;
        }

        override public function buildInputs(manager:PresetManager,
                                             style:WiredStyle,
                                             builder:WiredUIBuilder):void
        {
            this._prizeLimitInput = manager.createNumberInput(
                new NumberInputParam(1, 1, 1000, 60));
            var prizeLimitOption:CheckboxOptionParam = new CheckboxOptionParam(
                roomEvents.localization.getLocalizationWithParams(
                    "wiredfurni.params.prizelimit", "", "amount", ""), 0);
            prizeLimitOption.extra1 = this._prizeLimitInput;
            this._prizeLimitCheckbox = manager.createCheckboxGroup(
                [prizeLimitOption], this.onPrizeLimitToggle);
            var warningParam:TextParam = new TextParam(TextParam.MODE_MULTILINE, false);
            warningParam.textColor = 13369344;
            this._prizeLimitWarning = manager.createText(
                "Reward limit not set. Make sure rewards are badges or non-tradeable items.",
                warningParam);
            this._prizeLimitWarningHeight = this._prizeLimitWarning.window.height;
            var prizeLimitList:SimpleListViewPreset = manager.createSimpleListView(
                true, [this._prizeLimitCheckbox, this._prizeLimitWarning]);
            var prizeLimitSection:SectionPreset = manager.createSection(
                "Reward limit", prizeLimitList);

            this._rewardIntervalGroup = manager.createRadioGroup([
                new RadioButtonParam(0, "Once"),
                new RadioButtonParam(1, "1 / n Days"),
                new RadioButtonParam(2, "1 / n Hours"),
                new RadioButtonParam(3, "1 / n Mins")
            ], this.onRewardIntervalChange, 2);
            this._rewardIntervalInput = manager.createNamedTextInput(
                new TextInputParam("1", 4, null, 60, "0-9"), "n =");
            var intervalList:SimpleListViewPreset = manager.createSimpleListView(
                true, [this._rewardIntervalGroup, this._rewardIntervalInput]);
            var intervalSection:SectionPreset = manager.createSection(
                "How often can a user be rewarded", intervalList);

            var uniqueOption:CheckboxOptionParam = new CheckboxOptionParam(
                "Unique Rewards?", 0);
            uniqueOption.extra2 = manager.createText(
                "If checked each reward will be given once to each user. Probabilities are not in use.",
                new TextParam(TextParam.MODE_MULTILINE, false));
            this._uniquePrizeCheckbox = manager.createCheckboxGroup(
                [uniqueOption], this.onUniquePrizeToggle);
            var uniqueSection:SectionPreset = manager.createSection(
                "Unique Rewards", this._uniquePrizeCheckbox);

            this._rewardList = manager.createRewardList(
                MAX_REWARDS, this._displayedRewards);
            var addRewardButton:TextualButtonPreset =
                manager.createTextualButtonPreset("Add reward", this.onAddReward);
            var rewardsParam:SectionParam = new SectionParam();
            rewardsParam.addHeaderOption(addRewardButton);
            var rewardsSection:SectionPreset = manager.createSection(
                "Rewards", this._rewardList, rewardsParam);

            builder.addElements(prizeLimitSection, intervalSection,
                uniqueSection, rewardsSection);
            this.updatePrizeLimitState();
            this.onRewardIntervalChange(this._rewardIntervalGroup.selected);
        }

        override public function onEditStart(data:Triggerable):void
        {
            var intData:Array = data.intData != null ? data.intData : [];
            this._rewardIntervalGroup.selected =
                intData.length > 0 ? int(intData[0]) : 0;
            this._rewardIntervalInput.text =
                this._rewardIntervalGroup.selected > 0 && intData.length == 4
                    ? String(intData[3]) : "1";
            this.onRewardIntervalChange(this._rewardIntervalGroup.selected);

            var unique:Boolean = intData.length > 1 && int(intData[1]) == 1;
            this._uniquePrizeCheckbox.get(0).selected = unique;
            this.setProbabilityEnabled(!unique);

            var limit:int = intData.length > 2 ? int(intData[2]) : 0;
            if (limit > 0)
            {
                this._prizeLimitInput.value = limit;
                this._prizeLimitCheckbox.get(0).selected = true;
            }
            else
            {
                this._prizeLimitCheckbox.get(0).selected = false;
            }
            this.updatePrizeLimitState();

            this._displayedRewards = DEFAULT_REWARDS;
            var rewards:Array = data.stringData == null || data.stringData == ""
                ? [] : data.stringData.split(";");
            var index:int;
            while (index < MAX_REWARDS)
            {
                var row:RewardRowPreset = this._rewardList.getRow(index);
                if (rewards[index])
                {
                    this.setRewardData(row, rewards[index]);
                    this._displayedRewards = Math.max(
                        this._displayedRewards, index + 1);
                }
                else
                {
                    row.clear();
                }
                index++;
            }
            this._rewardList.setDisplayedRewards(this._displayedRewards);
        }

        override public function validate():String
        {
            var totalProbability:int;
            var unique:Boolean = this._uniquePrizeCheckbox.get(0).selected;
            var index:int;
            while (index < this._rewardList.displayedRewards)
            {
                var row:RewardRowPreset = this._rewardList.getRow(index);
                var error:String = this.validateReward(row, unique);
                if (error != null)
                {
                    return error;
                }
                if (!unique && row.probabilityText != "")
                {
                    totalProbability += int(row.probabilityText);
                }
                index++;
            }
            if (totalProbability > 100)
            {
                return "The sum of probabilities cannot exceed 100. You now have " +
                    totalProbability + ".";
            }
            return null;
        }

        override public function readIntParamsFromForm():Array
        {
            var interval:int = int(this._rewardIntervalInput.text);
            return [
                this._rewardIntervalGroup.selected,
                this._uniquePrizeCheckbox.get(0).selected ? 1 : 0,
                this._prizeLimitCheckbox.get(0).selected
                    ? this._prizeLimitInput.value : 0,
                interval >= 1 ? interval : 1
            ];
        }

        override public function readStringParamFromForm():String
        {
            var result:String = "";
            var index:int;
            while (index < this._rewardList.displayedRewards)
            {
                var reward:String = this.getRewardData(
                    this._rewardList.getRow(index));
                if (reward != null)
                {
                    result += (result == "" ? "" : ";") + reward;
                }
                index++;
            }
            return result;
        }

        private function onPrizeLimitToggle(index:int, selected:Boolean):void
        {
            if (index == 0)
            {
                this.updatePrizeLimitState();
            }
        }

        private function updatePrizeLimitState():void
        {
            var selected:Boolean = this._prizeLimitCheckbox.get(0).selected;
            this._prizeLimitWarning.visible = !selected;
            this._prizeLimitWarning.window.height =
                selected ? 0 : this._prizeLimitWarningHeight;
        }

        private function onUniquePrizeToggle(index:int, selected:Boolean):void
        {
            if (index == 0)
            {
                this.setProbabilityEnabled(!selected);
            }
        }

        private function setProbabilityEnabled(value:Boolean):void
        {
            this._rewardList.setProbabilityEnabled(value);
        }

        private function onAddReward():void
        {
            this._displayedRewards = Math.min(
                MAX_REWARDS, this._displayedRewards + 1);
            this._rewardList.setDisplayedRewards(this._displayedRewards);
        }

        private function onRewardIntervalChange(value:int):void
        {
            this._rewardIntervalInput.disabled = value == 0;
        }

        private function validateReward(row:RewardRowPreset,
                                        unique:Boolean):String
        {
            var codeValue:String = row.code;
            var probability:String = row.probabilityText;
            if (codeValue == "" && probability == "")
            {
                return null;
            }
            if (codeValue.indexOf(",") > 0)
            {
                return "Product/badge codes must not contain ',' characters.";
            }
            if (codeValue.indexOf(";") > 0)
            {
                return "Product/badge codes must not contain ';' characters.";
            }
            if (codeValue.length > 100)
            {
                return "Product/badge codes cannot contain more than 100 characters.";
            }
            if (codeValue == "")
            {
                return "Remember to define product/badge codes for all rewards (fill all fields or leave all fields empty).";
            }
            if (!unique)
            {
                if (probability == "")
                {
                    return "Remember to define probabilities for all rewards (fill all fields or leave all fields empty).";
                }
                if (isNaN(Number(probability)))
                {
                    return "Make sure are probabilities are numbers.";
                }
                var probabilityValue:int = int(probability);
                if (probabilityValue < 1 || probabilityValue > 100)
                {
                    return "Make sure all probabilities are numbers between 1 and 100.";
                }
            }
            return null;
        }

        private function getRewardData(row:RewardRowPreset):String
        {
            var codeValue:String = this.replaceAll(row.code, ";", "");
            codeValue = this.replaceAll(codeValue, ",", "");
            if (codeValue == "")
            {
                return null;
            }
            var probability:int = isNaN(Number(row.probabilityText))
                ? 0 : int(row.probabilityText);
            return (row.isBadge ? "0" : "1") + "," + codeValue + "," +
                probability;
        }

        private function setRewardData(row:RewardRowPreset, data:String):void
        {
            var parts:Array = data == null ? [] : data.split(",");
            row.code = parts[1] ? parts[1] : "";
            row.probabilityText = parts[2] ? parts[2] : "";
            row.isBadge = parts[0] && parts[0] == "0";
        }

        private function replaceAll(value:String,
                                    search:String,
                                    replacement:String):String
        {
            var remaining:int = 100;
            while (value.indexOf(search) > -1)
            {
                value = value.replace(search, replacement);
                if (--remaining < 1)
                {
                    break;
                }
            }
            return value;
        }
    }
}
