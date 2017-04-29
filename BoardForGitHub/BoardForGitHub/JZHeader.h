//
//  JZHeader.h
//  BoardForGitHub
//
//  Created by Justin Fincher on 2017/4/29.
//  Copyright © 2017年 Justin Fincher. All rights reserved.
//

#ifndef JZHeader_h
#define JZHeader_h

#pragma mark - Enum Factory Macros
// expansion macro for enum value definition
#define ENUM_VALUE(name,assign) name assign,

// expansion macro for enum to string conversion
#define ENUM_CASE(name,assign) case name: return @#name;

// expansion macro for string to enum conversion
#define ENUM_STRCMP(name,assign) if ([string isEqualToString:@#name]) return name;

/// declare the access function and define enum values
#define DECLARE_ENUM(EnumType,ENUM_DEF) \
typedef enum EnumType { \
ENUM_DEF(ENUM_VALUE) \
}EnumType; \
NSString *NSStringFrom##EnumType(EnumType value); \
EnumType EnumType##FromNSString(NSString *string); \

// Define Functions
#define DEFINE_ENUM(EnumType, ENUM_DEF) \
NSString *NSStringFrom##EnumType(EnumType value) \
{ \
switch(value) \
{ \
ENUM_DEF(ENUM_CASE) \
default: return @""; \
} \
} \
EnumType EnumType##FromNSString(NSString *string) \
{ \
ENUM_DEF(ENUM_STRCMP) \
return (EnumType)0; \
}

#define JZ_NOTIFICATON_TYPE(XX)  \
XX(JZ_NOTIFICATON_TYPE_OPEN_SETTINGS, ) \
XX(JZ_NOTIFICATON_TYPE_RELOAD_BOARD, ) \
XX(JZ_NOTIFICATON_TYPE_SWITCH_BOARD, ) \
XX(JZ_NOTIFICATON_TYPE_REVERT_BOARD, ) \
XX(JZ_NOTIFICATON_TYPE_SET_DEFAULT_BOARD, ) \
XX(JZ_NOTIFICATON_TYPE_FORWARD_BOARD, ) \
XX(JZ_NOTIFICATON_TYPE_ADD_CARDS_FROM, ) \
XX(JZ_NOTIFICATON_TYPE_SHOW_BOARD_MENU, )
DECLARE_ENUM(JZNotificationType, JZ_NOTIFICATON_TYPE)

#define JZ_USER_DEFAULTS_TYPE(XX)  \
XX(JZ_USER_DEFAULTS_SHOW_BOARD_SHORTCUT, ) \
XX(JZ_USER_DEFAULTS_LAUNCH_URL, ) \
XX(JZ_USER_DEFAULTS_VIBRANCY_BACKGROUND, ) \
XX(JZ_USER_DEFAULTS_ICON_BADGE_SHOW_TOTAL_CARDS_NUM, )
DECLARE_ENUM(JZUserDefaultsType, JZ_USER_DEFAULTS_TYPE)

#define NSTouchBarAvailable (NSClassFromString(@"NSTouchBar") != nil)

#endif /* JZHeader_h */
