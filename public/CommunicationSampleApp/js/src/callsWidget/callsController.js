(function (window, $) {
    'use strict';

    function CallsController(user, client) {
        this._user = user;
        this._client = client;
        this._calls = user.getCalls();
        this._callsView = new window.CallsView({
            handleAudioMakeCall: function (remoteAddress, requiresToken) {
                if (remoteAddress) {
                    this.makeCall(remoteAddress, requiresToken, false);
                } else {

                }
            }.bind(this),
            handleVideoMakeCall: function (remoteAddress, requiresToken) {
                if (remoteAddress) {
                    this.makeCall(remoteAddress, requiresToken, true);
                } else {

                }
            }.bind(this)
        });

        this._call = undefined;
        this._callController = undefined;
        this._init();
    }


    CallsController.prototype = {
        /**
         * Init function for Calls service.
         * Registration callbacks releated with Calls service.
         */
        _init: function () {
            this._calls.addOnCallsServiceAvailableCallback(function () {
                console.log("Client:addOnCallsServiceAvailableCallback");
            });

            this._calls.addOnIncomingCallCallback(function (call) {
                console.log("Client:addOnIncomingCallCallback");
                var hasVideo = false;
                if (call.getIncomingVideoOffered() === AvayaClientServices.Services.Call.VideoNetworkSignalingType.SUPPORTED) {
                    hasVideo = true;
                }

                this._call = call;

                this._callController = new window.CallController(this._call, this._client, hasVideo, this._callsView);
            }.bind(this));

            this._calls.removeOnCallCreatedCallback(function () {
                console.log("Client:removeOnCallCreatedCallback");
            });
            this._calls.removeOnCallRemovedCallback(function () {
                console.log("Client:removeOnCallRemovedCallback ");
            });
        },

        /**
         * Function make a call.
         *
         * @param {String} remoteAddress
         * @param {Boolean} requiresToken
         * @param {Boolean} hasVideo
         */
        makeCall: function (remoteAddress, requiresToken, hasVideo) {
            var callCreationInfo = new AvayaClientServices.Services.Call.CallCreationInfo(remoteAddress, false, 'Sample App Call');
            var isTokenNeeded = requiresToken;

            if (isTokenNeeded) {
                this.getToken(remoteAddress).then(function (token) {
                    callCreationInfo.setPortalToken(token);
                    callCreationInfo.setCallType(AvayaClientServices.Services.Call.CallType.CallTypeHttpMeetMe);
                    this._call = this._calls.createCall(callCreationInfo);
                    this.startCall(hasVideo);
                }.bind(this));
            } else {
                this._call = this._calls.createCall(callCreationInfo);
                this.startCall(hasVideo);
            }
        },

        /**
         * Function start call.
         *
         * @param {Boolean} hasVideo
         */
        startCall: function (hasVideo) {
            if (hasVideo) {
                this._call.setVideoMode(AvayaClientServices.Services.Call.VideoMode.SEND_RECEIVE);
            }

            this._callController = new window.CallController(this._call, this._client, hasVideo, this._callsView);

            this._call.start();
        },

        /**
         * Function used to get Scopia Conference token.
         *
         * @param meetingId
         * @returns {Promise}
         */
        getToken: function (meetingId) {
            var dfd = $.Deferred();
            var credentialProvider = this._user._config.sgConfiguration.credentialProvider;
            var networkProviderConfig = this._user._config.sgConfiguration.networkProviderConfiguration.restConfig;
            var upsHost = networkProviderConfig.hostName + ":" + networkProviderConfig.port;
            var upsHref = 'https://' + upsHost + "/ups/resources/middleware/token";
            var username = credentialProvider.username.split('@')[0];

            if (upsHref) {
                var data = {
                    userName: username,
                    conferenceId: meetingId,
                    presentationOnly: false,
                    passcode: null
                };
                var postRequest = {
                    method: 'POST',
                    url: upsHref,
                    withCredentials: true,
                    headers: {
                        'Accept': "application/vnd.avaya.portal.middleware.token.v1+json, application/vnd.avaya.csa.error.v1+json",
                        'Content-Type': "application/vnd.avaya.portal.middleware.token.v1+json"
                    },
                    data: JSON.stringify(data)
                };

                $.ajax(postRequest).then(function (data, textStatus, jqXHR) {
                    if (jqXHR.status == 200) {
                        if (data.error) {
                            dfd.reject("Failed to retrieve iView token: " + data.error.errorMsg);
                        } else {
                            console.log("Got iView token : " + data.token);
                            dfd.resolve(data.token);
                        }
                    } else {
                        dfd.reject("Failed to retrieve iView token: " + jqXHR.status + ' ' + jqXHR.statusText);
                    }
                }, function (jqXHR) {
                    dfd.reject("Failed to retrieve iView token: " + jqXHR.status + ' ' + jqXHR.statusText);
                });
            }
            return dfd.promise();
        }
    };

    window.CallsController = CallsController;

})(window, jQuery);
