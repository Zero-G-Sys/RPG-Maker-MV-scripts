//=============================================================================
// ZERO_webpSupport.js
//=============================================================================
/*:
 * @ZERO_webpSupport
 * @plugindesc Add support for webp images
 * @version 1.0
 * @author Zero_G
 * @filename ZERO_webpSupport.js
 * @help
 -------------------------------------------------------------------------------
 == Description ==
 Add support for webp images

 == Terms of Use ==
 - Free for use in non-commercial projects with credits
 - Free for use in commercial projects
 - Please provide credits to Zero_G

 == Usage ==
 Just add the plugin.

 == Changelog ==
 1.0 Initial
 
 -------------------------------------------------------------------------------

*/

var Imported = Imported || {};
var ZERO = ZERO || {};
Imported.ZERO_webpSupport = 1;
ZERO.webpSupport = ZERO.webpSupport || {};

(function ($) {
    var fs = require('fs'); // load fs module

    // Override
    ImageManager.loadBitmap = function(folder, filename, hue, smooth) {
        if (filename) {
            // Check if webp exists, otherwise load as png
            var path = folder + encodeURIComponent(filename) + '.webp'
            if(!fs.existsSync(path)) path = folder + encodeURIComponent(filename) + '.png';

            var bitmap = this.loadNormalBitmap(path, hue || 0);
            bitmap.smooth = smooth;
            return bitmap;
        } else {
            return this.loadEmptyBitmap();
        }
    };

    // Override
    ImageManager.reserveBitmap = function(folder, filename, hue, smooth, reservationId) {
        if (filename) {
            // Check if webp exists, otherwise load as png
            var path = folder + encodeURIComponent(filename) + '.webp'
            if(!fs.existsSync(path)) path = folder + encodeURIComponent(filename) + '.png';

            var bitmap = this.reserveNormalBitmap(path, hue || 0, reservationId || this._defaultReservationId);
            bitmap.smooth = smooth;
            return bitmap;
        } else {
            return this.loadEmptyBitmap();
        }
    };

    // Override
    ImageManager.requestBitmap = function(folder, filename, hue, smooth) {
        if (filename) {
            // Check if webp exists, otherwise load as png
            var path = folder + encodeURIComponent(filename) + '.webp'
            if(!fs.existsSync(path)) path = folder + encodeURIComponent(filename) + '.png';

            var bitmap = this.requestNormalBitmap(path, hue || 0);
            bitmap.smooth = smooth;
            return bitmap;
        } else {
            return this.loadEmptyBitmap();
        }
    };
  
})(ZERO.webpSupport);
