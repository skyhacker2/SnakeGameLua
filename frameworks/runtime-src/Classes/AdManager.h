//
//  AdManager.h
//  SnakeGameLua
//
//  Created by Eleven Chen on 14-8-21.
//
//

#ifndef __SnakeGameLua__AdManager__
#define __SnakeGameLua__AdManager__

#include "cocos2d.h"

class AdManager : public cocos2d::Ref
{
public:
    
    static AdManager* getInstance();
    
    static void destroyInstance();
  
    void showAds();
    
    void hideAds();
};

#endif /* defined(__SnakeGameLua__AdManager__) */
