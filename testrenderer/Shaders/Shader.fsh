//
//  Shader.fsh
//  testrenderer
//
//  Created by Philipp König on 03.08.13.
//  Copyright (c) 2013 Philipp König. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
