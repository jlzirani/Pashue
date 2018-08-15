function colorNormalise(color)
{
  return {"r": color['r']/255,
          "g": color['g']/255, 
          "b": color['b']/255};
}

function _correction(val)
{
  return (val > 0.04045) ? Math.pow((val + 0.055) / 1.055, 2.4) : (val / 12.92);
}

function colorCorrection(color)
{
  return {"r": _correction(color["r"]),
          "g": _correction(color["g"]),
          "b": _correction(color["b"])};
}

function colorNormAndCorrToXYB(color)
{
  var X = color["r"] * 0.664511 + color["g"] * 0.154324 + color["b"] * 0.162028;
  var Y = color["r"] * 0.283881 + color["g"] * 0.668433 + color["b"] * 0.047685;
  var Z = color["r"] * 0.000088 + color["g"] * 0.072310 + color["b"] * 0.986039;

  var xy = {"x": X / (X + Y + Z), "y": Y / (X + Y + Z), "bri": Y};

  if(isNaN(xy['x'])) xy['x'] = 0.0;
  if(isNaN(xy['y'])) xy['y'] = 0.0;

  return xy
}

function crossProduct(p1, p2)
{
  return (p1["x"] * p2["y"] - p1["y"] * p2["x"]);
}

function minusPoints(p1, p2)
{
  return {"x": p1["x"] - p2["x"],
          "y": p1["y"] - p2["y"]};
}

function getDistance(p1, p2)
{
  var dP = minusPoints(p1, p2);

  return Math.sqrt( dP["x"] * dP["x"] + dP["y"] * dP["y"]);
}


function checkPointInTriangle( p1, red, green, blue )
{
  var v1 = minusPoints(green, red); 
  var v2 = minusPoints(blue, red); 
  var q = minusPoints(p1, red); 

  var s = crossProduct(q, v2) / crossProduct(v1, v2);
  var t = crossProduct(v1, q) / crossProduct(v1, v2);

  return (s >= 0.0) && (t >= 0.0) && (s+t <= 1.0)
}

function getClosestPoint(p1, p2, p3)
{
  var AP = minusPoints(p1, p2);
  var AB = minusPoints(p3, p2);

  var AB2 = AB["x"] * AB["x"] + AB["y"] * AB["y"];
  var AP_AB = AP["x"] * AB["x"] + AP["y"] * AB["y"];

  var t = AP_AB / AB2;

  if( t < 0.0 ) t= 0.0;
  if( t > 1.0) t= 1.0;

  return {"x": p2["x"] + AB["x"]*t, "y": p2["y"] + AB["y"]*t};
}

function getXYFromRGB(color)
{
   var normCorColor = colorCorrection( colorNormalise( color ) );
   var xyb = colorNormAndCorrToXYB( normCorColor );

   var RED = {"x": 0.674, "y": 0.322 };
   var GREEN = {"x": 0.408, "y": 0.517};
   var BLUE = {"x": 0.168, "y": 0.041};

   var b = xyb["bri"];

   if( !checkPointInTriangle( xyb, RED, GREEN, BLUE ) )
   {
      var pAB = getClosestPoint( xyb, RED, GREEN );
      var pAC = getClosestPoint( xyb, BLUE, RED );
      var pBC = getClosestPoint( xyb, GREEN, BLUE); 

      var lowest = getDistance(xyb, pAB);
      var dAC = getDistance(xyb, pAC);
      var dBC = getDistance(xyb, pBC);
      
      xyb = pAB;

      if( lowest > dAC ) 
      {
        lowest = dAC;
        xyb = pAC;
      } 

      if( lowest > dBC ) 
      {
        lowest = dBC;
        xyb = pBC;
      }
   }
   xyb['bri'] = b;

   return xyb;
}

function getRGBFromXYB(pt, bri)
{
  var Y = bri/255;
  var X = (Y/pt["y"]) * pt["x"];
  var Z = (Y/pt["y"]) * (1.0 - pt["x"] - pt["y"]);

  var r = X * 1.656492 - Y * 0.354851 - Z * 0.255038;
  var g = -X * 0.707196 + Y * 1.655397 + Z * 0.036152;
  var b = X * 0.051713 - Y * 0.121364 + Z * 1.011530;

  r = (r <= 0.0031308) ? 12.92 * r : (1.055) * Math.pow(r, (1.0 / 2.4)) - 0.055;
  g = (g <= 0.0031308) ? 12.92 * g : (1.055) * Math.pow(g, (1.0 / 2.4)) - 0.055;
  b = (b <= 0.0031308) ? 12.92 * b : (1.055) * Math.pow(b, (1.0 / 2.4)) - 0.055;
 
  if( r >= b && r >= g && r > 1.0 )
  {
    g /= r;
    b /= r;
    r = 1.0;
  }

  if( g >= b && g >= r && g > 1.0 )
  {
    r /= g;
    b /= g;
    g = 1.0;
  }

  if( b >= g && b >= r && b > 1.0 )
  {
    r /= b;
    g /= b;
    b = 1.0;
  } 
  
  return {"r": Math.round(r*255),
          "g": Math.round(g*255),
          "b": Math.round(b*255)};
}

