float sdOrientedVesica( float2 p, float2 a, float2 b, float w )
{
    float r = 0.5*length(b-a);
    float d = 0.5*(r*r-w*w)/w;
    float2 v = (b-a)/r;
    float2 c = (b+a)*0.5;
    float2 q = 0.5*abs(mul((p-c), float2x2(v.y,v.x,-v.x,v.y)));
    float3 h = (r*q.x<d*(q.y-r)) ? float3(0.0,r,0.0) : float3(-d,0.0,d+w);
    return length( q-h.xy) - h.z;
}