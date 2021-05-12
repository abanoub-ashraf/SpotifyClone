import Foundation

/**
 * this is for the response of the exchanging code for access token api call
 * this is also for the response of the request for refresh token api call
 * first one return refresh token in the response and the second one doesn't, that's why refresh_token is optional
 */
struct AuthResponse: Codable {
    
    let access_token: String
    let expires_in: Int
    let refresh_token: String?
    let scope: String
    let token_type: String
    
}

/**
 * the json response we get from the api call of exchanging code for access token
 * we get that code from loading the url of the sign in authentication web page web
    {
        "access_token" = "BQD_Vtyi0PDESQealv5yxthqOR7zTb8VRL-NFm1gA3vZ7vdHBNmDf5vRMGfMR8ibVhJmsaURqWzg2JVf1HZmibtHJbYNan6U7JiUTcp-a-OdrGPuzwxakG7ZrhpgNPJtXdVGJG7Icrk6xMtZFdEjtm8duvtyWzuFeE9S5i6kv_YGjTQ";
        "expires_in" = 3600;
        "refresh_token" = "AQDdpCnx5nU3XFW23xnbazPICGL2Kr92yVu1OLNkM9J74glDLalnyKK194Bi01MOWNpq0rkWnOxs9ZYiYU_psidn0BHPPzddk5aq6IEnNp3A6nOx1mFLjUn6Oaupe4VlbzE";
        scope = "user-read-private";
        "token_type" = Bearer;
    }
*/
