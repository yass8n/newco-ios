//
//  FestivalData.m
//  now-sessions
//
//  Created by Yassen Aniss
//  Copyright Â© 2016 now. All rights reserved.
//

#import "Helper.h"

@implementation FestivalData
#import "constants.h"

@synthesize sessionsArray, sessionsDict, EVENT_COLORS_ARRAY, attendeesDict, sessionsAtDateAndTime, datesDict, orderOfInsertedDatesDict, companiesDict, currentUserSessions, locationColorDict, volunteersDict, presentersDict, audienceMapToSessions, locationMapToSessions, allFestivals;

+ (FestivalData *)sharedFestivalData
{
    static FestivalData *sharedFestivalData = nil;
    if (!sharedFestivalData) {
        sharedFestivalData = [[FestivalData alloc] init];
    }
    return sharedFestivalData;
}
-(void)clearAllData{
    datesDict = [[NSMutableDictionary alloc]init];
    sessionsArray = [[NSMutableArray alloc]init];
    sessionsDict = [[NSMutableDictionary alloc]init];
    sessionsAtDateAndTime = [[NSMutableDictionary alloc]init];
    attendeesDict = [[NSMutableDictionary alloc]init];
    presentersDict = [[NSMutableDictionary alloc]init];
    companiesDict = [[NSMutableDictionary alloc]init];
    volunteersDict = [[NSMutableDictionary alloc]init];
    orderOfInsertedDatesDict = [[NSMutableDictionary alloc]init];
    locationColorDict = [[NSMutableDictionary alloc]init];
    currentUserSessions = [[NSMutableDictionary alloc]init];
    audienceMapToSessions = [[NSMutableDictionary alloc]init];
    locationMapToSessions = [[NSMutableDictionary alloc]init];
}
- (id)init
{
    self = [super init];
    if (self){
        datesDict = [[NSMutableDictionary alloc]init];
        sessionsArray = [[NSMutableArray alloc]init];
        sessionsDict = [[NSMutableDictionary alloc]init];
        sessionsAtDateAndTime = [[NSMutableDictionary alloc]init];
        attendeesDict = [[NSMutableDictionary alloc]init];
        presentersDict = [[NSMutableDictionary alloc]init];
        companiesDict = [[NSMutableDictionary alloc]init];
        volunteersDict = [[NSMutableDictionary alloc]init];
        orderOfInsertedDatesDict = [[NSMutableDictionary alloc]init];
        locationColorDict = [[NSMutableDictionary alloc]init];
        currentUserSessions = [[NSMutableDictionary alloc]init];
        audienceMapToSessions = [[NSMutableDictionary alloc]init];
        locationMapToSessions = [[NSMutableDictionary alloc]init];
    }
    return self;
}
-(void)updateSessionsValidity:(NSArray*)eventKeys invalidateSessions:(BOOL)invalidate{
    for (int i = 0; i < [eventKeys count]; i++){
        NSString * event_key = [eventKeys objectAtIndex:i];
        Session* s = [sessionsDict objectForKey:event_key];
        s.picked = invalidate;
        NSString* dateAndTime = [s.worded_date and s.start_time];
        NSMutableDictionary* sessionsForThisDateAndTime = [sessionsAtDateAndTime objectForKey:dateAndTime];
        NSArray * sessions = [sessionsForThisDateAndTime allValues];
        for (int j = 0; j < [sessions count]; j++){
            Session * session = [sessions objectAtIndex:j];
            if (![session.event_key isEqual:event_key]){
                session.enabled = !invalidate;
                session.picked = NO;
            }
        }
        
    }
}
-(Session*)getConflictingSession:(Session*) session{
    NSString* dateAndTime = [session.worded_date and session.start_time];
    NSMutableDictionary* sessionsForThisDateAndTime = [sessionsAtDateAndTime objectForKey:dateAndTime];
    NSArray * sessions = [sessionsForThisDateAndTime allValues];
    for (int j = 0; j < [sessions count]; j++){
        Session * temp = [sessions objectAtIndex:j];
        if (temp.enabled){
            return temp;
        }
    }
    return nil;
}
- (UIColor *) findFreeColor{
    NSUInteger count = [[locationColorDict allKeys] count];
    return [EVENT_COLORS_ARRAY objectAtIndex:count];
}

-(void) initializeSessionArrayWithData:(NSArray *) jsonArray{
    for (int i = 0; i < jsonArray.count; i++){
        NSDictionary* session_ = [jsonArray objectAtIndex:i];
        NSString * active = [session_ objectForKey:@"active"];
        NSString * startString = [session_ objectForKey:@"event_start"];
        if ([active isEqualToString:@"Y"] ){
            if ([[[Credentials sharedCredentials].festival objectForKey:@"name"] isEqualToString:@"utopia"] &&
                ![startString hasPrefix:@"2017-08"]){
                continue;
            }
            NSString* description = [session_ objectForKey:@"description"];
            NSString* event_key = [session_ objectForKey:@"event_key"];
            NSString* lat = [session_ objectForKey:@"lat"];
            NSString* lon = [session_ objectForKey:@"lon"];
            NSString* name = [session_ objectForKey:@"name"];
            NSString* address = [session_ objectForKey:@"address"];
            NSDate* event_start = [Helper UTCtoNSDate:[session_ objectForKey:@"event_start"]];
            NSDate* event_end = [Helper UTCtoNSDate:[session_ objectForKey:@"event_end"]];
            
            NSString* location = [session_ objectForKey:@"event_type"];
            if ([location isEqual:[NSNull null]] || !location){ location = @""; };
            
            NSString* audience = [session_ objectForKey:@"audience"];
            if ([audience isEqual:[NSNull null]] || !audience){ audience = @""; };
            
            NSString* id_ = [session_ objectForKey:@"id"];
            NSArray* speakers = [session_ objectForKey:@"speakers"];
            NSArray* artists = [session_ objectForKey:@"artists"];
            NSString* status = [session_ objectForKey:@"seats-title"];
            NSInteger goers = [[session_ objectForKey:@"goers"] integerValue];
            NSInteger seats = [[session_ objectForKey:@"seats"] integerValue];
            
            NSString* firm_location;
            if (![location  isEqual: @""]){
                if ([location rangeOfString:@","].location == NSNotFound){
                    if (![locationColorDict objectForKey:location]){
                        //location can be a list of locations
                        [locationColorDict setObject:[self findFreeColor] forKey:location];
                    }
                } else {
                    NSArray *locations = [location componentsSeparatedByString:@","];
                    for (NSString* loc in locations) {
                        NSString* trimLoc = [loc stringByTrimmingCharactersInSet:
                                             [NSCharacterSet whitespaceCharacterSet]];
                        firm_location = trimLoc;
                        if (![locationColorDict objectForKey:trimLoc]){
                            //location can be a list of locations
                            [locationColorDict setObject:[self findFreeColor] forKey:trimLoc];
                        }
                    }
                }
            }
            
            Session *s = [[Session alloc] initWithTitle: name
                                              event_key: event_key
                                             event_type: location
                                                    id_: id_
                                                 status: status
                                                  note1: location
                                                  color: firm_location ? [locationColorDict objectForKey:firm_location] : [locationColorDict objectForKey:location]
                                            event_start: event_start
                                              event_end:event_end
                                                address: address
                                               audience: audience
                                               speakers: speakers
                                              companies: artists
                                            description: description
                                                  goers:goers
                                                  seats:seats
                                                  lat:lat
                                                  lon:lon];
            [sessionsArray addObject: s];
            [sessionsDict setObject:s forKey:s.event_key];
            
            if (audience && [audience length] > 0){
                if ([audience rangeOfString:@","].location == NSNotFound){
                    if (![audienceMapToSessions objectForKey:audience]){
                        NSMutableArray * array = [[NSMutableArray alloc]init];
                        [audienceMapToSessions setObject:array forKey:audience];
                    }
                    NSMutableArray * array = [audienceMapToSessions objectForKey:audience];
                    [array addObject:s];
                } else {
                    NSArray *audiences = [audience componentsSeparatedByString:@","];
                    for (NSString* aud in audiences) {
                        NSString* trimAud = [aud stringByTrimmingCharactersInSet:
                                             [NSCharacterSet whitespaceCharacterSet]];
                        if (![audienceMapToSessions objectForKey:trimAud]){
                            NSMutableArray * array = [[NSMutableArray alloc]init];
                            [audienceMapToSessions setObject:array forKey:trimAud];
                        }
                        NSMutableArray * array = [audienceMapToSessions objectForKey:trimAud];
                        [array addObject:s];
                    }
                }
            }
            
            
            if (location && [location length] > 0){
                if ([location rangeOfString:@","].location == NSNotFound){
                    if (![locationMapToSessions objectForKey:location]){
                        NSMutableArray * array = [[NSMutableArray alloc]init];
                        [locationMapToSessions setObject:array forKey:location];
                    }
                    NSMutableArray * array = [locationMapToSessions objectForKey:location];
                    [array addObject:s];
                } else {
                    NSArray *locations = [location componentsSeparatedByString:@","];
                    for (NSString* loc in locations) {
                        NSString* trimLoc = [loc stringByTrimmingCharactersInSet:
                                             [NSCharacterSet whitespaceCharacterSet]];
                        if (![locationMapToSessions objectForKey:trimLoc]){
                            NSMutableArray * array = [[NSMutableArray alloc]init];
                            [locationMapToSessions setObject:array forKey:trimLoc];
                        }
                        NSMutableArray * array = [locationMapToSessions objectForKey:trimLoc];
                        [array addObject:s];
                    }
                }
            }
        }
        
        
    }
    [self setDatesDict:datesDict setOrderOfInsertedDatesDict:orderOfInsertedDatesDict forSessions:sessionsArray initializeEverything:YES modifyOrderOfInsertedDictKeysByAddingNumber:1];
}
- (void)setDatesDict:(NSMutableDictionary*)datesDictionary setOrderOfInsertedDatesDict:(NSMutableDictionary*)orderOfInsertedDatesDictionary forSessions:(NSMutableArray*)sessions initializeEverything:(BOOL)initEverything modifyOrderOfInsertedDictKeysByAddingNumber:(NSUInteger)addingNumber{
    if (initEverything){
        sessionsAtDateAndTime = [[NSMutableDictionary alloc] init];
    }
    for (int i = 0; i < [sessions count]; i++){
        Session * s = [sessions objectAtIndex:i];
        if (initEverything){
            NSString* dateAndTime = [s.worded_date and s.start_time];
            if (![sessionsAtDateAndTime objectForKey:dateAndTime]){
                NSMutableDictionary * sessionsDic = [[NSMutableDictionary alloc]init];
                [sessionsAtDateAndTime setObject:sessionsDic forKey:dateAndTime];
            }
            NSMutableDictionary* sessionsDic = [sessionsAtDateAndTime objectForKey:dateAndTime];
            [sessionsDic setObject:s forKey:s.event_key];
        }
        if (![datesDictionary objectForKey:s.worded_date]){
            NSUInteger count =  [[datesDictionary allKeys] count];
            NSNumber *count_object = [NSNumber numberWithInteger:count + addingNumber];
            [orderOfInsertedDatesDictionary setObject:s.worded_date forKey:count_object];
            [datesDictionary setObject:[[NSMutableArray alloc] init] forKey:s.worded_date];
        }
        NSMutableArray * sessions_for_date = [datesDictionary objectForKey:s.worded_date];
        [sessions_for_date addObject:s];
    }
}
-(NSMutableArray *) allFestivals{
    return  allFestivals;
}

-(NSMutableArray*) sessionsArray{
    
    //    [self setSessionsArray:sessionsArray];
    return sessionsArray;
}
-(NSMutableDictionary*) sessionsDict {
    
    //    [self setSessionsDict:sessionsDict];
    return sessionsDict;
}
-(NSMutableDictionary*) datesDict {
    
    //    [self setDatesDict:datesDict];
    return datesDict;
}
-(NSMutableDictionary*) sessionsAtDateAndTime {
    
    //    [self setSessionsAtDateAndTime:sessionsAtDateAndTime];
    return sessionsAtDateAndTime;
}
-(NSMutableDictionary*) attendeesDict {
    
    //    [self setAttendeesDict:attendeesDict];
    return attendeesDict;
}

-(NSMutableDictionary*) presentersDict {
    
    //    [self setPresentersDict:presentersDict];
    return presentersDict;
}

-(NSMutableDictionary*) companiesDict {
    
    //    [self setCompaniesDict:companiesDict];
    return companiesDict;
}

-(NSMutableDictionary*) volunteersDict {
    
    //    [self setVolunteersDict:volunteersDict];
    return volunteersDict;
}
-(NSMutableDictionary*) orderOfInsertedDatesDict {
    
    //    [self setOrderOfInsertedDatesDict:orderOfInsertedDatesDict];
    return orderOfInsertedDatesDict;
}
-(NSMutableDictionary*) locationColorDict {
    
    //    [self setLocationColorDict:locationColorDict];
    return locationColorDict;
}
-(NSMutableDictionary*) currentUserSessions {
    
    //    [self setCurrentUserSessions:currentUserSessions];
    return currentUserSessions;
}
-(void) setAllFestivals:(NSMutableArray *)object{
    allFestivals = object;
}
-(void) setSessionsArray:(NSMutableArray *)object;
{
    sessionsArray = object;
    //    if ([sessionsArray count] > 0){
    //        NSData *archivedObject = [NSKeyedArchiver archivedDataWithRootObject: sessionsArray];
    //        NSUserDefaults *currentUserDefaults = [NSUserDefaults standardUserDefaults];
    //        [currentUserDefaults setObject:archivedObject forKey:@"sessionsArray"];
    //        [currentUserDefaults synchronize];
    //    }
}

- (void) setSessionsAtDateAndTime:(NSMutableDictionary *)object{
    sessionsAtDateAndTime = object;
    //    if ([sessionsAtDateAndTime count] > 0){
    //        NSData *archivedObject = [NSKeyedArchiver archivedDataWithRootObject: sessionsAtDateAndTime];
    //        NSUserDefaults *currentUserDefaults = [NSUserDefaults standardUserDefaults];
    //        [currentUserDefaults setObject:archivedObject forKey:@"sessionsAtDateAndTime"];
    //        [currentUserDefaults synchronize];
    //    }
}
- (void) setCurrentUserSessions:(NSMutableDictionary *)object{
    currentUserSessions = object;
    //    if ([currentUserSessions count] > 0){
    //        NSData *archivedObject = [NSKeyedArchiver archivedDataWithRootObject: currentUserSessions];
    //        NSUserDefaults *currentUserDefaults = [NSUserDefaults standardUserDefaults];
    //        [currentUserDefaults setObject:archivedObject forKey:@"currentUserSessions"];
    //        [currentUserDefaults synchronize];
    //    }
}

- (void) setSessionsDict:(NSMutableDictionary *)object{
    sessionsDict = object;
    //    if ([sessionsDict count] > 0){
    //        NSData *archivedObject = [NSKeyedArchiver archivedDataWithRootObject: sessionsDict];
    //        NSUserDefaults *currentUserDefaults = [NSUserDefaults standardUserDefaults];
    //        [currentUserDefaults setObject:archivedObject forKey:@"sessionsDict"];
    //        [currentUserDefaults synchronize];
    //    }
}

- (void)enableAllSessions{
    if (sessionsArray){
        for (int i = 0; i < [sessionsArray count]; i++) {
            Session * s = [sessionsArray objectAtIndex:i];
            s.enabled = YES;
            s.picked = NO;
        }
    }
}

- (void) setLocationColorDict:(NSMutableDictionary *)object{
    locationColorDict = object;
    //    if ([locationColorDict count] > 0){
    //        NSData *archivedObject = [NSKeyedArchiver archivedDataWithRootObject: locationColorDict];
    //        NSUserDefaults *currentUserDefaults = [NSUserDefaults standardUserDefaults];
    //        [currentUserDefaults setObject:archivedObject forKey:@"locationColorDict"];
    //        [currentUserDefaults synchronize];
    //    }
}

- (void) setOrderOfInsertedDatesDict:(NSMutableDictionary *)object{
    orderOfInsertedDatesDict = object;
    //    if ([orderOfInsertedDatesDict count] > 0){
    //        NSData *archivedObject = [NSKeyedArchiver archivedDataWithRootObject: orderOfInsertedDatesDict];
    //        NSUserDefaults *currentUserDefaults = [NSUserDefaults standardUserDefaults];
    //        [currentUserDefaults setObject:archivedObject forKey:@"orderOfInsertedDatesDict"];
    //        [currentUserDefaults synchronize];
    //    }
}

- (void) setCompaniesDict:(NSMutableDictionary *)object{
    companiesDict = object;
    //    if ([companiesDict count] > 0){
    //        NSData *archivedObject = [NSKeyedArchiver archivedDataWithRootObject: companiesDict];
    //        NSUserDefaults *currentUserDefaults = [NSUserDefaults standardUserDefaults];
    //        [currentUserDefaults setObject:archivedObject forKey:@"companiesDict"];
    //        [currentUserDefaults synchronize];
    //    }
}

- (void) setPresentersDict:(NSMutableDictionary *)object{
    presentersDict = object;
    //    if ([presentersDict count] > 0){
    //        NSData *archivedObject = [NSKeyedArchiver archivedDataWithRootObject: presentersDict];
    //        NSUserDefaults *currentUserDefaults = [NSUserDefaults standardUserDefaults];
    //        [currentUserDefaults setObject:archivedObject forKey:@"presentersDict"];
    //        [currentUserDefaults synchronize];
    //    }
}

- (void) setAttendeesDict:(NSMutableDictionary *)object{
    attendeesDict = object;
    //    if ([attendeesDict count] > 0){
    //        NSData *archivedObject = [NSKeyedArchiver archivedDataWithRootObject: attendeesDict];
    //        NSUserDefaults *currentUserDefaults = [NSUserDefaults standardUserDefaults];
    //        [currentUserDefaults setObject:archivedObject forKey:@"attendeesDict"];
    //        [currentUserDefaults synchronize];
    //    }
}

- (void) setDatesDict:(NSMutableDictionary *)object{
    datesDict = object;
    //    if ([datesDict count] > 0){
    //        NSData *archivedObject = [NSKeyedArchiver archivedDataWithRootObject: datesDict];
    //        NSUserDefaults *currentUserDefaults = [NSUserDefaults standardUserDefaults];
    //        [currentUserDefaults setObject:archivedObject forKey:@"datesDict"];
    //        [currentUserDefaults synchronize];
    //    }
}

- (void) setVolunteersDict:(NSMutableDictionary *)object{
    volunteersDict = object;
    //    if ([volunteersDict count] > 0){
    //        NSData *archivedObject = [NSKeyedArchiver archivedDataWithRootObject: volunteersDict];
    //        NSUserDefaults *currentUserDefaults = [NSUserDefaults standardUserDefaults];
    //        [currentUserDefaults setObject:archivedObject forKey:@"volunteersDict"];
    //        [currentUserDefaults synchronize];
    //    }
}
- (void)initEventColorsArray{
    if (EVENT_COLORS_ARRAY == nil){
        EVENT_COLORS_ARRAY = [[NSMutableArray alloc] initWithObjects:
                              [UIColor myDarkTeal],
                              [UIColor myDarkYellow],
                              [UIColor myPink],
                              [UIColor myLightGray],
                              [UIColor myLightOrange],
                              [UIColor myLightPink],
                              [UIColor myFadedTurquoise],
                              [UIColor myBrown],
                              [UIColor myTurquoise],
                              [UIColor myPuke],
                              [UIColor myRed],
                              [UIColor myGreen],
                              [UIColor myBlue],
                              [UIColor myOrange],
                              [UIColor myPurple],
                              [UIColor myTeal],
                              [UIColor myYellow],
                              [UIColor myPink],
                              [UIColor myDarkBlue],
                              [UIColor myDarkRed],
                              [UIColor myDarkPurple],
                              [UIColor myDarkOrange],
                              [UIColor myMiddleBlue],
                              [UIColor myLimeGreen],
                              [UIColor brownColor],
                              [UIColor lightGrayColor],
                              [UIColor greenColor],
                              [UIColor purpleColor],
                              [UIColor brownColor],
                              [UIColor lightGrayColor],
                              [UIColor greenColor],
                              [UIColor purpleColor],
                              [UIColor brownColor],
                              [UIColor lightGrayColor],
                              [UIColor greenColor],
                              [UIColor purpleColor],
                              [UIColor myDarkTeal],
                              [UIColor myDarkYellow],
                              [UIColor myPink],
                              [UIColor myLightGray],
                              [UIColor myLightOrange],
                              [UIColor myLightPink],
                              [UIColor myFadedTurquoise],
                              [UIColor myBrown],
                              [UIColor myTurquoise],
                              [UIColor myPuke],
                              [UIColor myRed],
                              [UIColor myGreen],
                              [UIColor myBlue],
                              [UIColor myOrange],
                              [UIColor myPurple],
                              [UIColor myTeal],
                              [UIColor myYellow],
                              [UIColor myPink],
                              [UIColor myDarkBlue],
                              [UIColor myDarkRed],
                              [UIColor myDarkPurple],
                              [UIColor myDarkOrange],
                              [UIColor myMiddleBlue],
                              [UIColor myLimeGreen],
                              nil];
    }
    
}


@end