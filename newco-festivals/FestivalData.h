//
//  FestivalData.h
//  now-sessions
//
//  Created by Yassen Aniss
//  Copyright © 2016 now. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FestivalData : NSObject

@property (nonatomic, retain) NSMutableArray *sessionsArray;
@property (nonatomic, retain) NSMutableDictionary *sessionsDict;
@property (nonatomic, retain) NSMutableDictionary* datesDict; //dates map to sessions in that date
@property (nonatomic, retain) NSMutableDictionary* sessionsAtDateAndTime; //date-time map to session.event_keys in that date-time
@property (nonatomic, retain) NSMutableDictionary* attendeesDict;
@property (nonatomic, retain) NSMutableDictionary* presentersDict;
@property (nonatomic, retain) NSMutableDictionary* companiesDict;
@property (nonatomic, retain) NSMutableDictionary* volunteersDict;
@property (nonatomic, retain) NSMutableDictionary* orderOfInsertedDatesDict; //numbers map to dates...nums start from 0 and increment
@property (nonatomic, retain) NSMutableDictionary* locationColorDict;
@property (nonatomic, retain) NSMutableDictionary* audienceMapToSessions;
@property (nonatomic, retain) NSMutableDictionary* locationMapToSessions;
@property (nonatomic, retain) NSMutableArray* EVENT_COLORS_ARRAY;
@property (nonatomic, retain) NSMutableArray* allFestivals;
@property (nonatomic, retain) NSMutableDictionary* currentUserSessions; //keys = session.event_key and value = @"YES"
- (void)initEventColorsArray;
-(void)updateSessionsValidity:(NSArray*)eventKeys invalidateSessions:(BOOL)invalidate;
-(void) enableAllSessions;
-(Session*)getConflictingSession:(Session*) session;
- (void)setDatesDict:(NSMutableDictionary*)datesDictionary setOrderOfInsertedDatesDict:(NSMutableDictionary*)orderOfInsertedDatesDictionary forSessions:(NSMutableArray*)sessions initializeEverything:(BOOL)initEverything modifyOrderOfInsertedDictKeysByAddingNumber:(NSUInteger)addingNumber;
-(void) initializeSessionArrayWithData:(NSArray *) jsonArray;
-(void) setSessionsArray:(NSMutableArray *)object;
-(void) setSessionsDict:(NSMutableDictionary *)object;
-(void) setLocationColorDict:(NSMutableDictionary *)object;
-(void) setOrderOfInsertedDatesDict:(NSMutableDictionary *)object;
-(void) setCompaniesDict:(NSMutableDictionary *)object;
-(void) setPresentersDict:(NSMutableDictionary *)object;
-(void) setAttendeesDict:(NSMutableDictionary *)object;
-(void) setDatesDict:(NSMutableDictionary *)object;
-(void) setSessionsAtDateAndTime:(NSMutableDictionary *)object;
-(void) setVolunteersDict:(NSMutableDictionary *)object;
-(void) setCurrentUserSessions:(NSMutableDictionary*) object;
-(void) setAllFestivals:(NSMutableArray *)object;
-(void) clearAllData;
+(FestivalData *) sharedFestivalData;
@end