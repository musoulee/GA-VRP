function distance = LngLat2Km(X, Y)
    lng1 = X(1); lat1 = X(2);
    lng2 = Y(1); lat2 = Y(2);
    tmp = sind((lat1-lat2)/2)^2 + cosd(lat1) * cosd(lat2) * (sind(lng1-lng2)/2)^2;
    distance = 2 * 111 * asind(sqrt(tmp));
end