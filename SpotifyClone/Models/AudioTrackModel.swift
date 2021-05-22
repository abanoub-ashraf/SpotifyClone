import Foundation

struct AudioTrackModel: Codable {
    let album: Album?
    let artists: [ArtistModel]
    let available_markets: [String]
    let disc_number: Int
    let duration_ms: Int
    let explicit: Bool
    let external_urls: [String: String]
    let id: String
    let name: String
}

/**
 tracks =     (
             {
         album =             {
             "album_type" = SINGLE;
             artists =                 (
                                     {
                     "external_urls" =                         {
                         spotify = "https://open.spotify.com/artist/1h6Cn3P4NGzXbaXidqURXs";
                     };
                     href = "https://api.spotify.com/v1/artists/1h6Cn3P4NGzXbaXidqURXs";
                     id = 1h6Cn3P4NGzXbaXidqURXs;
                     name = "Swedish House Mafia";
                     type = artist;
                     uri = "spotify:artist:1h6Cn3P4NGzXbaXidqURXs";
                 }
             );
             "available_markets" =                 (
                 AD,
                 AE,
                 AG,
                 AL,
                 AM,
                 AO,
                 AR,
                 AT,
                 AU,
                 AZ,
                 BA,
                 BB,
                 BD,
                 BE,
                 BF,
                 BG,
                 BH,
                 BI,
                 BJ,
                 BN,
                 BO,
                 BR,
                 BS,
                 BT,
                 BW,
                 BY,
                 BZ,
                 CA,
                 CH,
                 CI,
                 CL,
                 CM,
                 CO,
                 CR,
                 CV,
                 CW,
                 CY,
                 CZ,
                 DE,
                 DJ,
                 DK,
                 DM,
                 DO,
                 DZ,
                 EC,
                 EE,
                 EG,
                 ES,
                 FI,
                 FJ,
                 FM,
                 FR,
                 GA,
                 GB,
                 GD,
                 GE,
                 GH,
                 GM,
                 GN,
                 GQ,
                 GR,
                 GT,
                 GW,
                 GY,
                 HK,
                 HN,
                 HR,
                 HT,
                 HU,
                 ID,
                 IE,
                 IL,
                 IN,
                 IS,
                 IT,
                 JM,
                 JO,
                 JP,
                 KE,
                 KG,
                 KH,
                 KI,
                 KM,
                 KN,
                 KR,
                 KW,
                 KZ,
                 LA,
                 LB,
                 LC,
                 LI,
                 LK,
                 LR,
                 LS,
                 LT,
                 LU,
                 LV,
                 MA,
                 MC,
                 MD,
                 ME,
                 MG,
                 MH,
                 MK,
                 ML,
                 MN,
                 MO,
                 MR,
                 MT,
                 MU,
                 MV,
                 MW,
                 MX,
                 MY,
                 MZ,
                 NA,
                 NE,
                 NG,
                 NI,
                 NL,
                 NO,
                 NP,
                 NR,
                 NZ,
                 OM,
                 PA,
                 PE,
                 PG,
                 PH,
                 PK,
                 PL,
                 PS,
                 PT,
                 PW,
                 PY,
                 QA,
                 RO,
                 RS,
                 RU,
                 RW,
                 SA,
                 SB,
                 SC,
                 SE,
                 SG,
                 SI,
                 SK,
                 SL,
                 SM,
                 SN,
                 SR,
                 ST,
                 SV,
                 SZ,
                 TD,
                 TG,
                 TH,
                 TL,
                 TN,
                 TO,
                 TR,
                 TT,
                 TV,
                 TW,
                 TZ,
                 UA,
                 UG,
                 US,
                 UY,
                 UZ,
                 VC,
                 VN,
                 VU,
                 WS,
                 XK,
                 ZA,
                 ZM,
                 ZW
             );
             "external_urls" =                 {
                 spotify = "https://open.spotify.com/album/3RKhRsifs4RWrqvWV1YpPY";
             };
             href = "https://api.spotify.com/v1/albums/3RKhRsifs4RWrqvWV1YpPY";
             id = 3RKhRsifs4RWrqvWV1YpPY;
             images =                 (
                                     {
                     height = 640;
                     url = "https://i.scdn.co/image/ab67616d0000b2739cfe80c0c05ce104f7bab18e";
                     width = 640;
                 },
                                     {
                     height = 300;
                     url = "https://i.scdn.co/image/ab67616d00001e029cfe80c0c05ce104f7bab18e";
                     width = 300;
                 },
                                     {
                     height = 64;
                     url = "https://i.scdn.co/image/ab67616d000048519cfe80c0c05ce104f7bab18e";
                     width = 64;
                 }
             );
             name = "Don't You Worry Child";
             "release_date" = "2012-09-14";
             "release_date_precision" = day;
             "total_tracks" = 4;
             type = album;
             uri = "spotify:album:3RKhRsifs4RWrqvWV1YpPY";
         };
         artists =             (
                             {
                 "external_urls" =                     {
                     spotify = "https://open.spotify.com/artist/1h6Cn3P4NGzXbaXidqURXs";
                 };
                 href = "https://api.spotify.com/v1/artists/1h6Cn3P4NGzXbaXidqURXs";
                 id = 1h6Cn3P4NGzXbaXidqURXs;
                 name = "Swedish House Mafia";
                 type = artist;
                 uri = "spotify:artist:1h6Cn3P4NGzXbaXidqURXs";
             },
                             {
                 "external_urls" =                     {
                     spotify = "https://open.spotify.com/artist/2auikkNYqigWStoHWK1Grq";
                 };
                 href = "https://api.spotify.com/v1/artists/2auikkNYqigWStoHWK1Grq";
                 id = 2auikkNYqigWStoHWK1Grq;
                 name = "John Martin";
                 type = artist;
                 uri = "spotify:artist:2auikkNYqigWStoHWK1Grq";
             }
         );
         "available_markets" =             (
             AD,
             AE,
             AG,
             AL,
             AM,
             AO,
             AR,
             AT,
             AU,
             AZ,
             BA,
             BB,
             BD,
             BE,
             BF,
             BG,
             BH,
             BI,
             BJ,
             BN,
             BO,
             BR,
             BS,
             BT,
             BW,
             BY,
             BZ,
             CA,
             CH,
             CI,
             CL,
             CM,
             CO,
             CR,
             CV,
             CW,
             CY,
             CZ,
             DE,
             DJ,
             DK,
             DM,
             DO,
             DZ,
             EC,
             EE,
             EG,
             ES,
             FI,
             FJ,
             FM,
             FR,
             GA,
             GB,
             GD,
             GE,
             GH,
             GM,
             GN,
             GQ,
             GR,
             GT,
             GW,
             GY,
             HK,
             HN,
             HR,
             HT,
             HU,
             ID,
             IE,
             IL,
             IN,
             IS,
             IT,
             JM,
             JO,
             JP,
             KE,
             KG,
             KH,
             KI,
             KM,
             KN,
             KR,
             KW,
             KZ,
             LA,
             LB,
             LC,
             LI,
             LK,
             LR,
             LS,
             LT,
             LU,
             LV,
             MA,
             MC,
             MD,
             ME,
             MG,
             MH,
             MK,
             ML,
             MN,
             MO,
             MR,
             MT,
             MU,
             MV,
             MW,
             MX,
             MY,
             MZ,
             NA,
             NE,
             NG,
             NI,
             NL,
             NO,
             NP,
             NR,
             NZ,
             OM,
             PA,
             PE,
             PG,
             PH,
             PK,
             PL,
             PS,
             PT,
             PW,
             PY,
             QA,
             RO,
             RS,
             RU,
             RW,
             SA,
             SB,
             SC,
             SE,
             SG,
             SI,
             SK,
             SL,
             SM,
             SN,
             SR,
             ST,
             SV,
             SZ,
             TD,
             TG,
             TH,
             TL,
             TN,
             TO,
             TR,
             TT,
             TV,
             TW,
             TZ,
             UA,
             UG,
             US,
             UY,
             UZ,
             VC,
             VN,
             VU,
             WS,
             XK,
             ZA,
             ZM,
             ZW
         );
         "disc_number" = 1;
         "duration_ms" = 212862;
         explicit = 0;
         "external_ids" =             {
             isrc = GBAAA1200728;
         };
         "external_urls" =             {
             spotify = "https://open.spotify.com/track/2V65y3PX4DkRhy1djlxd9p";
         };
         href = "https://api.spotify.com/v1/tracks/2V65y3PX4DkRhy1djlxd9p";
         id = 2V65y3PX4DkRhy1djlxd9p;
         "is_local" = 0;
         name = "Don't You Worry Child - Radio Edit";
         popularity = 78;
         "preview_url" = "<null>";
         "track_number" = 1;
         type = track;
         uri = "spotify:track:2V65y3PX4DkRhy1djlxd9p";
     },
             {
         album =             {
             "album_type" = ALBUM;
             artists =                 (
                                     {
                     "external_urls" =                         {
                         spotify = "https://open.spotify.com/artist/66lH4jAE7pqPlOlzUKbwA0";
                     };
                     href = "https://api.spotify.com/v1/artists/66lH4jAE7pqPlOlzUKbwA0";
                     id = 66lH4jAE7pqPlOlzUKbwA0;
                     name = "Miranda Lambert";
                     type = artist;
                     uri = "spotify:artist:66lH4jAE7pqPlOlzUKbwA0";
                 }
             );
             "available_markets" =                 (
                 AD,
                 AE,
                 AG,
                 AL,
                 AM,
                 AO,
                 AR,
                 AT,
                 AU,
                 AZ,
                 BA,
                 BB,
                 BD,
                 BE,
                 BF,
                 BG,
                 BH,
                 BI,
                 BJ,
                 BN,
                 BO,
                 BR,
                 BS,
                 BT,
                 BW,
                 BY,
                 BZ,
                 CA,
                 CH,
                 CI,
                 CL,
                 CM,
                 CO,
                 CR,
                 CV,
                 CW,
                 CY,
                 CZ,
                 DE,
                 DJ,
                 DK,
                 DM,
                 DO,
                 DZ,
                 EC,
                 EE,
                 EG,
                 ES,
                 FI,
                 FJ,
                 FM,
                 FR,
                 GA,
                 GB,
                 GD,
                 GE,
                 GH,
                 GM,
                 GN,
                 GQ,
                 GR,
                 GT,
                 GW,
                 GY,
                 HK,
                 HN,
                 HR,
                 HT,
                 HU,
                 ID,
                 IE,
                 IL,
                 IN,
                 IS,
                 IT,
                 JM,
                 JO,
                 JP,
                 KE,
                 KG,
                 KH,
                 KI,
                 KM,
                 KN,
                 KR,
                 KW,
                 KZ,
                 LA,
                 LB,
                 LC,
                 LI,
                 LK,
                 LR,
                 LS,
                 LT,
                 LU,
                 LV,
                 MA,
                 MC,
                 MD,
                 ME,
                 MG,
                 MH,
                 MK,
                 ML,
                 MN,
                 MO,
                 MR,
                 MT,
                 MU,
                 MV,
                 MW,
                 MX,
                 MY,
                 MZ,
                 NA,
                 NE,
                 NG,
                 NI,
                 NL,
                 NO,
                 NP,
                 NR,
                 NZ,
                 OM,
                 PA,
                 PE,
                 PG,
                 PH,
                 PK,
                 PL,
                 PS,
                 PT,
                 PW,
                 PY,
                 QA,
                 RO,
                 RS,
                 RU,
                 RW,
                 SA,
                 SB,
                 SC,
                 SE,
                 SG,
                 SI,
                 SK,
                 SL,
                 SM,
                 SN,
                 SR,
                 ST,
                 SV,
                 SZ,
                 TD,
                 TG,
                 TH,
                 TL,
                 TN,
                 TO,
                 TR,
                 TT,
                 TV,
                 TW,
                 TZ,
                 UA,
                 UG,
                 US,
                 UY,
                 UZ,
                 VC,
                 VN,
                 VU,
                 WS,
                 XK,
                 ZA,
                 ZM,
                 ZW
             );
             "external_urls" =                 {
                 spotify = "https://open.spotify.com/album/3uczBfJFFSNjSiF8ScC1pA";
             };
             href = "https://api.spotify.com/v1/albums/3uczBfJFFSNjSiF8ScC1pA";
             id = 3uczBfJFFSNjSiF8ScC1pA;
             images =                 (
                                     {
                     height = 640;
                     url = "https://i.scdn.co/image/ab67616d0000b273c771f702f64d760b1be4f2be";
                     width = 640;
                 },
                                     {
                     height = 300;
                     url = "https://i.scdn.co/image/ab67616d00001e02c771f702f64d760b1be4f2be";
                     width = 300;
                 },
                                     {
                     height = 64;
                     url = "https://i.scdn.co/image/ab67616d00004851c771f702f64d760b1be4f2be";
                     width = 64;
                 }
             );
             name = Revolution;
             "release_date" = "2009-09-24";
             "release_date_precision" = day;
             "total_tracks" = 15;
             type = album;
             uri = "spotify:album:3uczBfJFFSNjSiF8ScC1pA";
         };
         artists =             (
                             {
                 "external_urls" =                     {
                     spotify = "https://open.spotify.com/artist/66lH4jAE7pqPlOlzUKbwA0";
                 };
                 href = "https://api.spotify.com/v1/artists/66lH4jAE7pqPlOlzUKbwA0";
                 id = 66lH4jAE7pqPlOlzUKbwA0;
                 name = "Miranda Lambert";
                 type = artist;
                 uri = "spotify:artist:66lH4jAE7pqPlOlzUKbwA0";
             }
         );
         "available_markets" =             (
             AD,
             AE,
             AG,
             AL,
             AM,
             AO,
             AR,
             AT,
             AU,
             AZ,
             BA,
             BB,
             BD,
             BE,
             BF,
             BG,
             BH,
             BI,
             BJ,
             BN,
             BO,
             BR,
             BS,
             BT,
             BW,
             BY,
             BZ,
             CA,
             CH,
             CI,
             CL,
             CM,
             CO,
             CR,
             CV,
             CW,
             CY,
             CZ,
             DE,
             DJ,
             DK,
             DM,
             DO,
             DZ,
             EC,
             EE,
             EG,
             ES,
             FI,
             FJ,
             FM,
             FR,
             GA,
             GB,
             GD,
             GE,
             GH,
             GM,
             GN,
             GQ,
             GR,
             GT,
             GW,
             GY,
             HK,
             HN,
             HR,
             HT,
             HU,
             ID,
             IE,
             IL,
             IN,
             IS,
             IT,
             JM,
             JO,
             JP,
             KE,
             KG,
             KH,
             KI,
             KM,
             KN,
             KR,
             KW,
             KZ,
             LA,
             LB,
             LC,
             LI,
             LK,
             LR,
             LS,
             LT,
             LU,
             LV,
             MA,
             MC,
             MD,
             ME,
             MG,
             MH,
             MK,
             ML,
             MN,
             MO,
             MR,
             MT,
             MU,
             MV,
             MW,
             MX,
             MY,
             MZ,
             NA,
             NE,
             NG,
             NI,
             NL,
             NO,
             NP,
             NR,
             NZ,
             OM,
             PA,
             PE,
             PG,
             PH,
             PK,
             PL,
             PS,
             PT,
             PW,
             PY,
             QA,
             RO,
             RS,
             RU,
             RW,
             SA,
             SB,
             SC,
             SE,
             SG,
             SI,
             SK,
             SL,
             SM,
             SN,
             SR,
             ST,
             SV,
             SZ,
             TD,
             TG,
             TH,
             TL,
             TN,
             TO,
             TR,
             TT,
             TV,
             TW,
             TZ,
             UA,
             UG,
             US,
             UY,
             UZ,
             VC,
             VN,
             VU,
             WS,
             XK,
             ZA,
             ZM,
             ZW
         );
         "disc_number" = 1;
         "duration_ms" = 236626;
         explicit = 0;
         "external_ids" =             {
             isrc = USG4X0900074;
         };
         "external_urls" =             {
             spotify = "https://open.spotify.com/track/02eD9ymfJOJOhM97HYp5R9";
         };
         href = "https://api.spotify.com/v1/tracks/02eD9ymfJOJOhM97HYp5R9";
         id = 02eD9ymfJOJOhM97HYp5R9;
         "is_local" = 0;
         name = "The House That Built Me";
         popularity = 67;
         "preview_url" = "https://p.scdn.co/mp3-preview/fae3074a59e9879c2372dbe5c6d5b20da1abd1f1?cid=bb1312f49f7542158a2b30791c1d421e";
         "track_number" = 10;
         type = track;
         uri = "spotify:track:02eD9ymfJOJOhM97HYp5R9";
     }
 );
 */
