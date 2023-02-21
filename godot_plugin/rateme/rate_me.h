//
//  rate_me.hpp
//  godot_plugin
//
//  Created by Denis Belov on 3/11/22.
//  Copyright © 2022 Godot. All rights reserved.
//

#ifndef rate_me_hpp
#define rate_me_hpp

#pragma once

#include "core/object.h"

class RateMe : public Object {
    GDCLASS(RateMe, Object);
    
    static void _bind_methods();
    
public:
    void showRateMe ();
    
    RateMe();
    ~RateMe();
};

#endif /* rate_me_hpp */
