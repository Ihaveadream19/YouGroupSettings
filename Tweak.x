#import <YouTubeHeader/YTIIcon.h>

#import <YouTubeHeader/YTSettingsGroupData.h>

#import <PSHeader/Misc.h>

#define LOC(x) [tweakBundle localizedStringForKey:x value:nil table:nil]

@interface YTSettingsGroupData (YouGroupSettings)

+ (NSMutableArray <NSNumber *> *)tweaks;

@end

// 🔥 ORIGINAL SECTION

static const NSInteger TweakGroup = 'psyt';

// 🆕 NEW SECTION (deine eigene)

static const NSInteger SponsorGroup = 'sprg';

static const NSInteger YTIcons = 'ytic';

static const NSInteger YouChooseQuality = 'ycql';

static const NSInteger YTUHD = 'ythd';

static const NSInteger YouSlider = 'ytsl';

static const NSInteger YTweaks = 'ytwk';

static const NSInteger YTFlags = 'ytfl';

static const NSInteger VolumeBoostYT = 'ndyt';

static const NSInteger YouMod = 'ytmo';

NSBundle *TweakBundle() {

    static NSBundle *bundle = nil;

    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{

        NSString *tweakBundlePath = [[NSBundle mainBundle] pathForResource:@"YouGroupSettings" ofType:@"bundle"];

        bundle = [NSBundle bundleWithPath:tweakBundlePath ?: PS_ROOT_PATH_NS(@"/Library/Application Support/YouGroupSettings.bundle")];

    });

    return bundle;

}

#pragma mark - Add Sections

%hook YTAppSettingsGroupPresentationData

+ (NSArray <YTSettingsGroupData *> *)orderedGroups {

    NSArray *groups = %orig;

    NSMutableArray *mutableGroups = [groups mutableCopy];

    // 🔹 Original Tweaks Section

    YTSettingsGroupData *tweakGroup =

        [[%c(YTSettingsGroupData) alloc] initWithGroupType:TweakGroup];

    // 🔸 New Sponsor/My Section

    YTSettingsGroupData *sponsorGroup =

        [[%c(YTSettingsGroupData) alloc] initWithGroupType:SponsorGroup];

    // Reihenfolge:

    [mutableGroups insertObject:tweakGroup atIndex:0];

    [mutableGroups insertObject:sponsorGroup atIndex:1];

    return mutableGroups;

}

%end

#pragma mark - Group Logic

%hook YTSettingsGroupData

%new(@@:)

+ (NSMutableArray <NSNumber *> *)tweaks {

    static NSMutableArray *tweaks = nil;

    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{

        tweaks = [NSMutableArray new];

        [tweaks addObjectsFromArray:@[

            @(404),

            @(YTIcons),

            @(YTweaks),

            @(VolumeBoostYT),

            @(2002),

            @(YTFlags),

            @(YouMod),

            @(500),

            @(517),

            @(1080),

            @(YTUHD),

            @(YouChooseQuality),

            @(200),

            @(YouSlider),

            @(2168),

            @(1222),

        ]];

    });

    return tweaks;

}

- (NSString *)titleForSettingGroupType:(NSUInteger)type {

    if (type == TweakGroup) {

        return LOC(@"TWEAKS");

    }

    if (type == SponsorGroup) {

        return @"Sponsor"; // 🔥 DEINE NEUE SECTION

    }

    return %orig;

}

- (NSArray <NSNumber *> *)orderedCategoriesForGroupType:(NSUInteger)type {

    if (type == TweakGroup)

        return [[self class] tweaks];

    if (type == SponsorGroup)

        return @[]; // leer = nur Header sichtbar

    return %orig;

}

%end

#pragma mark - Icon Fix

%hook YTSettingsViewController

- (void)setSectionItems:(NSMutableArray *)sectionItems

         forCategory:(NSInteger)category

               title:(NSString *)title

                icon:(YTIIcon *)icon

  titleDescription:(NSString *)titleDescription

      headerHidden:(BOOL)headerHidden {

    if (icon == nil && [[%c(YTSettingsGroupData) tweaks] containsObject:@(category)]) {

        icon = [%c(YTIIcon) new];

        icon.iconType = YT_SETTINGS;

    }

    %orig;

}

%end
