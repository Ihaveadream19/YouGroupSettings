#import <UIKit/UIKit.h>

#import <Foundation/Foundation.h>

#import <YouTubeHeader/YTSettingsGroupData.h>

#import <YouTubeHeader/YTIIcon.h>

#define TweakGroup 'psyt'

#define YTIcons 'ytic'

#define YouChooseQuality 'ycql'

#define YTUHD 'ythd'

#define YouSlider 'ytsl'

#define YTweaks 'ytwk'

#define LOC(x) [[NSBundle mainBundle] localizedStringForKey:x value:nil table:nil]

@interface YTSettingsGroupData (YouGroupSettings)

+ (NSMutableArray<NSNumber *> *)tweaks;

@end

static NSBundle *TweakBundle(void) {

    static NSBundle *bundle;

    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{

        NSString *path = [[NSBundle mainBundle] pathForResource:@"YouGroupSettings" ofType:@"bundle"];

        if (!path) {

            path = @"/Library/Application Support/YouGroupSettings.bundle";

        }

        bundle = [NSBundle bundleWithPath:path];

    });

    return bundle;

}

%hook YTAppSettingsGroupPresentationData

+ (NSArray *)orderedGroups {

    NSMutableArray *groups = [%orig mutableCopy];

    YTSettingsGroupData *group =

        [[%c(YTSettingsGroupData) alloc] initWithGroupType:TweakGroup];

    if (group) {

        [groups insertObject:group atIndex:0];

    }

    return groups;

}

%end

%hook YTSettingsGroupData

%new

+ (NSMutableArray<NSNumber *> *)tweaks {

    static NSMutableArray *tweaks;

    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{

        tweaks = [@[

            @(YTIcons),

            @(YTweaks),

            @(YouChooseQuality),

            @(YTUHD),

            @(YouSlider),

            @(1080),   // Return YouTube Dislike

            @(517),    // DontEatMyContent

            @(200),    // YouPiP

            @(2168),   // YTHoldForSpeed

            @(1222)    // YTVideoOverlay

        ] mutableCopy];

    });

    return tweaks;

}

- (NSString *)titleForSettingGroupType:(NSUInteger)type {

    if (type == TweakGroup) {

        return @"Tweaks";

    }

    return %orig;

}

- (NSArray *)orderedCategoriesForGroupType:(NSUInteger)type {

    if (type == TweakGroup) {

        return [[self class] tweaks];

    }

    return %orig;

}

%end

%hook YTSettingsViewController

- (void)setSectionItems:(NSMutableArray *)items

           forCategory:(NSInteger)category

                  title:(NSString *)title

                  icon:(YTIIcon *)icon

      titleDescription:(NSString *)desc

         headerHidden:(BOOL)hidden {

    if (!icon && [[%c(YTSettingsGroupData) tweaks] containsObject:@(category)]) {

        YTIIcon *newIcon = [%c(YTIIcon) new];

        newIcon.iconType = 44;

        icon = newIcon;

    }

    %orig(items, category, title, icon, desc, hidden);

}

%end
