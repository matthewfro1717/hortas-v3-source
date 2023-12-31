package;

#if desktop
import Discord.DiscordClient;
#end
#if sys
import sys.io.File;
import sys.FileSystem;
#end
import haxe.Json;
import haxe.format.JsonParser;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxSound; 
import flixel.text.FlxText;

using StringTools;

class CharacterSelectionState extends MusicBeatState {

	public var characterData:Array<Dynamic> = [
        [[["Boyfriend", 'bf'], ["Pixel Boyfriend", 'bf-pixel']], [1.0, 1.0, 1.0, 1.0]], 
        [[["Gold Bambi", 'gold-bambi']], [1.0, 1.0, 1.0, 1.0]], 
        [[["Bambi", 'bambi'], ["Bambi (Angry)", 'mewhennopizzarolls'], ["Bambi (Overthink)", 'bambioverthink'], ["Bambi (Mad)", 'mareloangry'], ["Bambi (God)", 'kalmpokebam'],  ["Bambi (Old)", 'bambiold'], ["Epitome", 'epitomeMan']], [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0]],
        [[["Expunged", '3dbambi'], ["Expunged (Unfair)", 'unfairbambi'], ["Expunged (Opposition)", 'oppositionexpunged'], ["Expunged (Thearchy)", 'thearchyexpunged'], ["Expunged (Phono)", 'phonophobiaexpunged'], ["Expunged (Green)", 'newgreen'], ["Expunged (Theoretical)", 'TheorExpunged']], [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0]],
        [[["HELLBREAKER", 'hellbreaker']], [1.0, 1.0]],
        [[["Opposiiton X", 'oppositionx'], ["Opposiiton X (Faker)", 'faker']], [1.0, 1.0, 1.0, 1.0]],
        [[["Potent Bambi", 'potentbambi'], ["Potent Bambi (Potent 2)", 'potentbambismilebitch']], [1.0, 1.0, 1.0, 1.0]],
        [[["Samber", 'samber'], ["Samber (Mac Party)", 'sambermacparty'], ], [1.0, 1.0, 1.0, 1.0]],
        [[["Saper", 'Saper']], [1.0, 1.0]],
        [[["Conbi", 'conbi']], [1.0, 1.0]],
        [[["Bamb", 'Bamb']], [1.0, 1.0]],
        [[["degnupxE", 'degnupxe']], [1.0, 1.0]],
        [[["Bumbo", 'bumbo']], [1.0, 1.0]],
        [[["Idiot", 'idiot']], [1.0, 1.0]],
        [[["Seven", '3dseven']], [1.0, 1.0]],
        [[["Orbi", 'Orbi']], [1.0, 1.0]],
        [[["Linbi", 'linbi']], [1.0, 1.0]],
        [[["Dortas", 'dortas']], [1.0, 1.0]],
        [[["Bambice", 'bambice']], [1.0, 1.0]],
        [[["Bambinton", 'bambinton']], [1.0, 1.0]],
        [[["Carl", 'carl']], [1.0, 1.0]],
        [[["Banbi", 'banbi'], ["Banbi (Origin)", 'Hjoim']], [1.0, 1.0, 1.0, 1.0]],
        [[["GOD", 'god']], [1.0, 1.0]],
        [[["El Mati", 'descarga']], [1.0, 1.0]],
        [[["Gary", 'Gary']], [1.0, 1.0]],
        [[["Nampi", 'nampi']], [1.0, 1.0]],
        [[["Benson", 'Benson']], [1.0, 1.0]],
        [[["Nimbi", 'nimbi']], [1.0, 1.0]],
    ];
    var characterSprite:Boyfriend;
    var characterFile:String = 'bf';

	var nightColor:FlxColor = 0xFF878787;
    var curSelected:Int = 0;
    var curSelectedForm:Int = 0;
    var curText:FlxText;
    var controlsText:FlxText;
    var formText:FlxText;
    var entering:Bool = false;

    var otherText:FlxText;
    var yesText:FlxText;
    var noText:FlxText;
    var previewMode:Bool = false;


    override function create() 
    {
        var rawJson = null;
		
		#if MODS_ALLOWED
		var moddyFile:String = Paths.modsJson('playablecharacters');
		if(FileSystem.exists(moddyFile)) {
            #if sys
			rawJson = File.getContent(moddyFile).trim();
            #else
            rawJson = Assets.getText(moddyFile).trim();
            #end
		}
		#end

		if(rawJson == null) {
			#if sys
			rawJson = File.getContent(Paths.json('playablecharacters')).trim();
			#else
			rawJson = Assets.getText(Paths.json('playablecharacters')).trim();
			#end
		}

        characterData = cast Json.parse(rawJson);

        FlxG.mouse.visible = true;
        FlxG.mouse.enabled = true;
        FlxG.sound.music.stop();
        FlxG.sound.playMusic(Paths.music('breakfast'), 1);
        var theBGNight:BGSprite = new BGSprite('sky_night', -680, -90, 0, 0);
        add(theBGNight);
        var hillsNight:BGSprite = new BGSprite('orangey hills', -380, 120, 0.3, 0.3);
        add(hillsNight);
        hillsNight.color = nightColor;
        var farmNight:BGSprite = new BGSprite('funfarmhouse', 80, 160, 0.6, 0.6);
        add(farmNight);
        farmNight.color = nightColor;
        var groundNight:BGSprite = new BGSprite('grass lands', -480, 560, 1, 1);
        add(groundNight);
        groundNight.color = nightColor;
        var corn1night:BGSprite = new BGSprite('Cornys', -360, 285, 1, 1);
        add(corn1night);
        corn1night.color = nightColor;
        var corn2night:BGSprite = new BGSprite('Cornys', 1060, 285, 1, 1);
        add(corn2night);
        corn2night.color = nightColor;
        var fenceNight:BGSprite = new BGSprite('crazy fences', -310, 450, 1, 1);
        add(fenceNight);
        fenceNight.color = nightColor;
        var signNight:BGSprite = new BGSprite('Sign', 10, 455, 1, 1);
        add(signNight);
        signNight.color = nightColor;
        signNight.y -= 50;
        fenceNight.y -= 50;
        corn2night.y -= 50;
        corn1night.y -= 50;
        groundNight.y -= 50;
        farmNight.y -= 50;
        hillsNight.y -= 50;
        theBGNight.y -= 50;

        if(PlayState.SONG.player1 != "bf")
            {
                otherText = new FlxText(10, 150, 0, 'This song does not use BF as the player\nor has a different variant of BF.\nDo you want to continue without changing character?\n', 20);
                otherText.setFormat(Paths.font("comicsanslol.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
                otherText.size = 45;
                otherText.screenCenter(X);
                add(otherText);
                yesText = new FlxText(FlxG.width / 4, 350, 0, 'Yes', 20);
                yesText.setFormat(Paths.font("comicsanslol.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
                yesText.size = 45;
                add(yesText);
                noText = new FlxText(FlxG.width / 1.5, 350, 0, 'No', 20);
                noText.setFormat(Paths.font("comicsanslol.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
                noText.size = 45;
                add(noText);
            }
        else {
            spawnSelection();
        }

        super.create();
    }

    var selectionStart:Bool = false;

    function spawnSelection()
        {
            selectionStart = true;
            characterSprite = new Boyfriend(0, 0, "bf", false, [-5, 0]);
            add(characterSprite);
            characterSprite.dance();
            characterSprite.screenCenter(XY);
            curText = new FlxText(0, 20, 0, characterData[curSelected][0][0][0], 20);
            curText.setFormat(Paths.font("comicsanslol.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            curText.size = 50;
            
            controlsText = new FlxText(10, 50, 0, 'Left or right to change character.\nUp or down to change form.\nPress P to enter preview mode.\n', 20);
            controlsText.setFormat(Paths.font("comicsanslol.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            controlsText.size = 20;
    
    
            add(curText);
            add(formText);
            add(controlsText);
    
            curText.screenCenter(X);
        }

    function checkPreview()
        {
            if(previewMode)
                {
                    controlsText.text = "PREVIEW MODE\nPress I to play idle animation.\nPress your controls to play an animation.\n";
                }
            else {
                controlsText.text = "Left or right to change character.\nUp or down to change form.\nPress P to enter preview mode.\n";
                if(characterSprite.animOffsets.exists('idle'))
                    {
                        characterSprite.playAnim('idle');
                    }
            }
        }
    override function update(elapsed)
    {
        if(FlxG.keys.justPressed.P && selectionStart)
            {
                previewMode = !previewMode;
                checkPreview();
            }
        if(selectionStart && !previewMode)
            {
                if(controls.UI_RIGHT_P)
                    {
                        changeCharacter(1);
                    }
                if(controls.UI_LEFT_P)
                    {
                        changeCharacter(-1);
                    }
                if(controls.UI_DOWN_P)
                    {
                        changeForm(1);
                    }
                if(controls.UI_UP_P)
                    {
                        changeForm(-1);
                    }
                if(controls.ACCEPT)
                    {
                        acceptCharacter();
                    }
            }
            else if (!previewMode)
            {
                if(controls.UI_RIGHT_P)
                    {
                        curSelected += 1;
                    }
                if(controls.UI_LEFT_P)
                    {
                        curSelected =- 1;
                    }
                if (curSelected < 0)
                    {
                        curSelected = 0;
                    }
                    if (curSelected >= 2)
                    {
                        curSelected = 0;
                    }
                switch(curSelected)
                {
                    case 0:
                        yesText.alpha = 1;
                        noText.alpha = 0.5;
                    case 1:
                        noText.alpha = 1;
                        yesText.alpha = 0.5;
                }
                if(controls.ACCEPT)
                    {
                        switch(curSelected)
                        {
                            case 0:
                                FlxG.sound.music.stop();
                                LoadingState.loadAndSwitchState(new PlayState());
                            case 1:
                                noText.alpha = 0;
                                yesText.alpha = 0;
                                otherText.alpha = 0;
                                curSelected = 0;
                                spawnSelection();
                                
                        }
                    }
            }
            else
                {
                    if(controls.NOTE_LEFT_P)
                        {
                            if(characterSprite.animOffsets.exists('singLEFT'))
                                {
                                    characterSprite.playAnim('singLEFT');
                                }
                        }
                    if(controls.NOTE_DOWN_P)
                        {
                            if(characterSprite.animOffsets.exists('singDOWN'))
                                {
                                    characterSprite.playAnim('singDOWN');
                                }
                        }
                    if(controls.NOTE_UP_P)
                        {
                            if(characterSprite.animOffsets.exists('singUP'))
                                {
                                    characterSprite.playAnim('singUP');
                                }
                        }
                    if(controls.NOTE_RIGHT_P)
                        {
                            if(characterSprite.animOffsets.exists('singRIGHT'))
                                {
                                    characterSprite.playAnim('singRIGHT');
                                }
                        }
                    if(FlxG.keys.justPressed.I)
                        {
                            if(characterSprite.animOffsets.exists('idle'))
                                {
                                    characterSprite.playAnim('idle');
                                }
                        }
                }
                if (controls.BACK)
                    {
                        FlxG.sound.music.stop();
                        MusicBeatState.switchState(new FreeplayState());
                        FlxG.sound.playMusic(Paths.music('freakyMenu'));
                    }
        super.update(elapsed);
    }


    function changeCharacter(change:Int) 
    {
        FlxG.sound.play(Paths.sound('scrollMenu'));
        curSelectedForm = 0;
        curSelected += change;

        if (curSelected < 0)
        {
			curSelected = characterData.length - 1;
        }
		if (curSelected >= characterData.length)
        {
			curSelected = 0;
        }
        curText.text = characterData[curSelected][0][0][0];
        characterFile = characterData[curSelected][0][0][1];
        reloadCharacter();

        curText.screenCenter(X);
    }

    function changeForm(change:Int) 
        {
            if(characterData[curSelected][0].length >= 2)
            {
                FlxG.sound.play(Paths.sound('scrollMenu'));
                curSelectedForm += change;
    
                if (curSelectedForm < 0)
                {
                    curSelectedForm = characterData[curSelected][0].length;
                    curSelectedForm = curSelectedForm - 1;
                }
                if (curSelectedForm >= characterData[curSelected][0].length)
                {
                    curSelectedForm = 0;
                }
                curText.text = characterData[curSelected][0][curSelectedForm][0];
                characterFile = characterData[curSelected][0][curSelectedForm][1];

                reloadCharacter();
        
                curText.screenCenter(X);
            }
        }

    function reloadCharacter()
        {
            characterSprite.destroy();
            if (characterData[curSelected][1][curSelectedForm][2] is Array) {
                characterSprite = new Boyfriend(0, 0, characterFile, false, characterData[curSelected][1][curSelectedForm][2]);
            } else {
                characterSprite = new Boyfriend(0, 0, characterFile, characterData[curSelected][1][curSelectedForm][2], [-5, 0]);
            }
            add(characterSprite);
            characterSprite.dance();
            characterSprite.scale.x = characterData[curSelected][1][curSelectedForm][0];
            characterSprite.scale.y = characterData[curSelected][1][curSelectedForm][1];
            characterSprite.screenCenter(XY);
        }
    function acceptCharacter() 
    {
        if(!entering)
        {
        entering = true;
        if(characterSprite.animOffsets.exists('hey'))
            {
                characterSprite.playAnim('hey');
            }
        else if(characterSprite.animOffsets.exists('singUP'))
            {
                characterSprite.playAnim('singUP');
            }
        FlxG.sound.playMusic(Paths.music('gameOverEnd'), 1);
        new FlxTimer().start(1.5, function(tmr:FlxTimer)
			{
                FlxG.sound.music.stop();
                PlayState.SONG.player1 = characterFile;
                LoadingState.loadAndSwitchState(new PlayState());
			});
        }
    }
}
