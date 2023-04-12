package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;
import flixel.addons.display.FlxBackdrop;

import touchInput;
using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.5b'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	
	
	var optionShit:Array<String> = [
		'story_mode',
		'freeplay',
		'awards',
		'options',
		'credits'
	];

	var overlay:FlxSprite;
	var menushit:FlxSprite;
	var magenta:FlxSprite;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var debugKeys:Array<FlxKey>;
	//var chess:FlxSprite;
	var chess:FlxBackdrop;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		WeekData.setDirectoryFromWeek();
		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement);
		FlxCamera.defaultCameras = [camGame];

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.scrollFactor.set(0, yScroll);
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		
		chess = new FlxBackdrop(Paths.image('mmbg'), 0, 0, true, false);
		chess.scrollFactor.set(0, 0.1);
		chess.y -= 80;
		add(chess);
		
		chess.offset.x -= 0;
		chess.offset.y += 0;
		chess.velocity.x = 20;


		var gradient:FlxSprite = new FlxSprite(0).loadGraphic(Paths.image('fpbgradient'));
		gradient.scrollFactor.set(0, 0);
		gradient.updateHitbox();
		gradient.screenCenter();
		gradient.antialiasing = ClientPrefs.globalAntialiasing;
		add(gradient);

		
		menushit = new FlxSprite();
		menushit.frames = Paths.getSparrowAtlas('MENU/shit');
		menushit.antialiasing = ClientPrefs.globalAntialiasing;
		menushit.animation.addByPrefix('story',"storymode",24);	
		menushit.animation.addByPrefix('free',"freeplay",24);
		menushit.animation.addByPrefix('awa',"awards",24);			
		menushit.animation.addByPrefix('opt',"options",24);	
		menushit.animation.addByPrefix('cred',"credits",24);	
		menushit.animation.play('story');
		menushit.scrollFactor.set(0, 0.1);
		menushit.x -= 1200;
		menushit.screenCenter(Y);
		add(menushit);
	
		//vem
		FlxTween.tween(menushit, {x:-150}, 2.4, {ease: FlxEase.expoInOut});

		overlay = new FlxSprite(0).loadGraphic(Paths.image('mmov2'));
		overlay.scrollFactor.set(0, 0);
		overlay.x += 1200;
		overlay.updateHitbox();
		overlay.antialiasing = ClientPrefs.globalAntialiasing;
		add(overlay);

		//vem
		FlxTween.tween(overlay, {x:0}, 2.4, {ease: FlxEase.expoInOut});

		


		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.set(0, yScroll);
		magenta.setGraphicSize(Std.int(magenta.width * 1.175));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = ClientPrefs.globalAntialiasing;
		magenta.color = 0xFFfd719b;
		add(magenta);
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var scale:Float = 0.4;
		/*if(optionShit.length > 6) {
			scale = 6 / optionShit.length;
		}*/

		for (i in 0...optionShit.length)
		{
			var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
			var menuItem:FlxSprite = new FlxSprite(0, (i * 130)  + offset);
			menuItem.scale.x = scale;
			menuItem.scale.y = scale;
			menuItem.x += 2000;
			//menuItem.y -= 50;
			
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			//menuItem.screenCenter(X);
			menuItems.add(menuItem);
			var scr:Float = (optionShit.length - 4) * 0.135;
			if(optionShit.length < 6) scr = 0;
			menuItem.scrollFactor.set(0, scr);
			menuItem.antialiasing = ClientPrefs.globalAntialiasing;
			//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
			menuItem.updateHitbox();
			menuItem.scale.set(0.8, 0.8);

			switch(i)
			{
				case 0:
					FlxTween.tween(menuItem, {x:650}, 2.4, {ease: FlxEase.expoInOut});
				case 1:
					FlxTween.tween(menuItem, {x:620}, 2.4, {ease: FlxEase.expoInOut});
				case 2:
					FlxTween.tween(menuItem, {x:590}, 2.4, {ease: FlxEase.expoInOut});
				case 3:
					FlxTween.tween(menuItem, {x:560}, 2.4, {ease: FlxEase.expoInOut});
				case 4:
					FlxTween.tween(menuItem, {x:530}, 2.4, {ease: FlxEase.expoInOut});
				case 5:
					FlxTween.tween(menuItem, {x:500}, 2.4, {ease: FlxEase.expoInOut});
			}
			
		}


		//faz a coisa
		FlxG.camera.flash(FlxColor.BLACK, 1.5);
		

		FlxG.camera.follow(camFollowPos, null, 1);

		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "Psych Engine v" + psychEngineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

		

		changeItem();

		#if ACHIEVEMENTS_ALLOWED
		Achievements.loadAchievements();
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18) {
			var achieveID:Int = Achievements.getAchievementIndex('friday_night_play');
			if(!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2])) { //It's a friday night. WEEEEEEEEEEEEEEEEEE
				Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
				giveAchievement();
				ClientPrefs.saveSettings();
			}
		}
		#end

		super.create();
	}

	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	function giveAchievement() {
		add(new AchievementObject('friday_night_play', camAchievement));
		FlxG.sound.play(Paths.sound('achievement'), 0.7);
		trace('Giving achievement "friday_night_play"');
	}
	#end

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.5, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			menuItems.forEach(function(spr:FlxSprite){
				if(touchInput.simpleTouch(spr)){
					curSelected = spr.ID;
					changeItem(spr.ID);
					selectThing();
				}
			});
				
			if (controls.ACCEPT)
				selectThing();
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			//spr.screenCenter(X);
		});
	}

	function goToState()
	{
		var daChoice:String = optionShit[curSelected];

		switch (daChoice)
		{									
			case 'story_mode':
				MusicBeatState.switchState(new StoryMenuState());
			case 'freeplay':
				MusicBeatState.switchState(new FreeplayState());
			case 'awards':
				MusicBeatState.switchState(new AchievementsMenuState());
			case 'credits':
				MusicBeatState.switchState(new CreditsState());
			case 'options':
				MusicBeatState.switchState(new options.OptionsState());
		}
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		switch (curSelected)
		{
			case 0:
				menushit.animation.play('story');
				case 1:
					menushit.animation.play('free');
					case 2:
						menushit.animation.play('awa');
						case 3:
							menushit.animation.play('opt');
							case 4:
							menushit.animation.play('cred');
		}

	/*	switch (curSelected)
		{
			case 0:
				cg.animation.play('idle');
			case 1:
				cg.animation.play('fix');
				cg.animation.finishCallback = function(fix)
					{
						cg.animation.play('fix2');
					}
			case 2:
				cg.animation.play('tape');
				cg.animation.finishCallback = function(tape)
					{
						cg.animation.play('tape2');
					}
			case 3:
				cg.animation.play('idle');
		}
*/
		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.updateHitbox();

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				var add:Float = 0;
				if(menuItems.length > 4) {
					add = menuItems.length * 8;
				}
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y - add);
				spr.centerOffsets();
			}
		});
	}

	function selectThing()
	{
		selectedSomethin = true;
		FlxG.sound.play(Paths.sound('confirmMenu'));
		FlxG.camera.flash(FlxColor.WHITE, 1);

		FlxTween.tween(overlay, {x: -2000}, 2.2, {ease: FlxEase.expoInOut});
		FlxTween.tween(menushit, {y:1500}, 1.2, {ease: FlxEase.expoIn});

		menuItems.forEach(function(spr:FlxSprite)
		{
			if (curSelected != spr.ID)
			{
				FlxTween.tween(spr, {x: 2000}, 2.2, {
					ease: FlxEase.expoInOut,
				});
							
			}
			else
			{
				FlxTween.tween(spr, {x: -2000}, 2.2, {
					ease: FlxEase.expoInOut,
				});

				FlxTween.tween(spr, {alpha: 0}, 3.2, {
					ease: FlxEase.expoInOut,
				});
							

				FlxFlicker.flicker(spr, 1, 1, false, false, function(flick:FlxFlicker)
				{
					goToState();
				});
			}
		});
	}
}
