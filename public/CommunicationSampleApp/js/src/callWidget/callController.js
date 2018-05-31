(function (window) {
    'use strict';

    function CallController(call, client, hasVideo, callsView) {
        this._call = call;
        this._conference = undefined;
        this._collaboration = undefined;
        this._client = client;
        this._user = this._client.user;
        this._hasVideo = hasVideo;

        this.callsView = callsView;

        this._time = 0;
        this._timerInterval = undefined;

        this._template = this.callsView.createCallTemplate();

        this._callView = new window.CallView(this._template, {
            handleEndCall: function () {
                this.endCall();
            }.bind(this),
            handleAcceptAudioCall: function () {
                this.acceptCall();
            }.bind(this),
            handleAcceptVideoCall: function () {
                this._call.setVideoMode(AvayaClientServices.Services.Call.VideoMode.SEND_RECEIVE);
                this.acceptCall();
            }.bind(this),
            handleIgnoreCall: function () {
                this.ignoreCall();
            }.bind(this),
            handleMuteUnmute: function () {
                this.muteUnmute();
            }.bind(this),
            handleHoldUnholdCall: function () {
                this.holdUnholdCall();
            }.bind(this),
            handleBlockUnblockVideo: function () {
                this.blockUnblockVideo();
            }.bind(this),
            handleSendDTMF: function (dtmf) {
                this.sendDTMF(dtmf);
            }.bind(this)
        });

        this._init();
    }


    CallController.prototype = {
        /**
         * Init function for Call.
         * Registration callbacks releated with Call.
         */
        _init: function () {
            this.callsView.collapseAll();
            this.callsView.addCallTemplate(this._template);

            if (this._hasVideo && this._call.isIncoming()) {
                this._callView.showIncomingVideoCall(this._call.getRemoteAddress());
            } else if (!this._hasVideo && this._call.isIncoming()) {
                this._callView.showIncomingAudioCall(this._call.getRemoteAddress());
            } else if (!this._call.isIncoming()) {
                this._callView.showLocalCall(this._call.getRemoteAddress());
            }

            this._callView.setCallTitle();
            this._callView.setCallId(this._call.getCallId());
            this._call.addOnCallConferenceStatusChangedCallback(function (call, isConference, uccpUrl, webCollabUrl) {
                if (isConference) {
                    this._callView.setConferenceTitle();

                    var uccpConfig = {
                        enabled: true
                    };

                    if (uccpUrl) {
                        var parsedUrl = AvayaClientServices.Base.Utils.parseUrl(uccpUrl);
                        var webSocketConfig = new AvayaClientServices.Config.ServerInfo(parsedUrl.hostname, parsedUrl.port, parsedUrl.isSecure, parsedUrl.path, parsedUrl.credentials, parsedUrl.query);
                        uccpConfig = {
                            enabled: true,
                            networkProviderConfiguration: {
                                webSocketConfig: webSocketConfig
                            }
                        };
                    }

                    if (webCollabUrl) {
                        var parsedWCSConfig = this._parseWcsConfig(webCollabUrl);
                        if (parsedWCSConfig) {
                            this._user._config.wcsConfiguration = parsedWCSConfig;
                            this._collaboration = new window.CollaborationController(this._user, call, parsedWCSConfig.meetingId, this.callsView);
                        }
                    }

                    this._conference = new window.ConferenceController(call, uccpConfig, this._template);
                }
            }.bind(this));

            this._call._addOnCallStateChangedCallback(function () {
				if (this._call.isHeldRemotely()) {
					this._callView.changeCallState('Held Remotely');
				} else {
					this._callView.changeCallState(this._call._callState);
				}
            }.bind(this));

            this._call.addOnCallEstablishedCallback(function (call) {
                this._callView.setCallId(call.getCallId());
                this._callView.showCallControlPanel(call, this._hasVideo);
                this._startTimer();
            }.bind(this));

			this._call.addOnCallHeldRemotelyCallback(function (call) {
				this._callView.changeCallState('Held Remotely');
			}.bind(this));
			
			this._call.addOnCallUnheldRemotelyCallback(function (call) {
				this._callView.changeCallState(this._call._callState);
			}.bind(this));
			
            this._call.addOnCallFailedCallback(function (call, error) {
                if (error && error.getError()) {
                    this._callView.showCallFailedInformation(error.getError());
                } else {
                    this._callView.showCallFailedInformation();
                }
                this.callsView.removeTemplate(this._template);
            }.bind(this));

            this._call.addOnCallRemoteAlertingCallback(function () {
                this._callView.showRemoteAlerting();
            }.bind(this));

            this._call.addOnCallHeldCallback(function () {
                this._pauseTimer();
                this._callView.changeHoldUnholdBtn(true);
            }.bind(this));

            this._call.addOnCallUnheldCallback(function () {
                this._startTimer();
                this._callView.changeHoldUnholdBtn(false);
            }.bind(this));

            this._call.addOnCallEndedCallback(function () {
                this._callView.hideCallPanel();
                this._stopTimer();
                if (this._collaboration) {
                    this._collaboration.removeCollaboration();
                }
                this.callsView.removeTemplate(this._template);
            }.bind(this));

            this._call.addOnCallIgnoredCallback(function () {
                this._callView.disableIgnoreButton();
            }.bind(this));

            this._call.addOnCallVideoChannelsUpdatedCallback(function (call) {
                console.log("Client: addOnCallVideoChannelsUpdatedCallback called ");
                this._updateVideoStreams(call);
            }.bind(this));
        },

        /**
         * Function used to end a call.
         */
        endCall: function () {
            this._call.end();
        },

        /**
         * Function used to accept incoming call.
         */
        acceptCall: function () {
            this._call.accept();
        },

        /**
         * Function used to ignore incoming call.
         */
        ignoreCall: function () {
            this._call.ignore();
        },

        /**
         * Function used to mute/unmute call.
         */
        muteUnmute: function () {
            this._call.addOnCallAudioMuteStatusChangedCallback(function (c, isMuted) {
                this._callView.changeMuteUnmuteBtn(isMuted);
            }.bind(this));

            this._call.getMuteCapability().addOnChangedCallback(function () {
                console.trace("call.getMuteCapability().addOnChangedCallback executed " + this._call.getMuteCapability().isAllowed);
            }.bind(this));

            if (this._call.isAudioMuted() === false) {
                this._call.muteAudio();
            } else {
                this._call.unmuteAudio();
            }
        },

        /**
         * Function used to hold/unhold call.
         */
        holdUnholdCall: function () {
            if (this._call.getHoldCapability().isAllowed) {
                this._call.hold();
            } else {
                this._call.unhold();
            }
        },

        /**
         * Function used to block/unblock video in call.
         */
        blockUnblockVideo: function () {
            var isBlocked;
            var vChannels = this._call.getVideoChannels();
            if (vChannels[0].getNegotiatedDirection() === "sendrecv") {
                isBlocked = true;
                this._call.setVideoMode(AvayaClientServices.Services.Call.VideoMode.RECEIVE_ONLY);
                this._callView.changeBlockUnblockBtn(isBlocked);
            } else if (vChannels[0].getNegotiatedDirection() === "recvonly") {
                isBlocked = false;
                this._call.setVideoMode(AvayaClientServices.Services.Call.VideoMode.SEND_RECEIVE);
                this._callView.changeBlockUnblockBtn(isBlocked);
            }
        },

        /**
         * Function used to send DTMF.
         *
         * @param {String} dtmf
         */
        sendDTMF: function (dtmf) {
            this._call.sendDTMF(dtmf);
        },

        /**
         * Function used to update video stream.
         *
         * @param {Object} call
         * @private
         */
        _updateVideoStreams: function (call) {
            var mediaEngine = this._client.getMediaServices();
            var videoChannels = call.getVideoChannels();
            if (videoChannels[0]) {
                var localStream;
                var remoteStream;
                switch (videoChannels[0].getNegotiatedDirection()) {
                    case AvayaClientServices.Services.Call.MediaDirection.RECV_ONLY:
                        this._callView.setLocalStream('');
                        remoteStream = mediaEngine.getVideoInterface().getRemoteMediaStream(videoChannels[0].getChannelId());
                        if (AvayaClientServices.Base.Utils.isDefined(remoteStream)) {
                            this._callView.setRemoteStream(URL.createObjectURL(remoteStream));
                        }
                        break;
                    case AvayaClientServices.Services.Call.MediaDirection.SEND_ONLY:
                        localStream = mediaEngine.getVideoInterface().getLocalMediaStream(videoChannels[0].getChannelId());
                        if (AvayaClientServices.Base.Utils.isDefined(localStream)) {
                            this._callView.setLocalStream(URL.createObjectURL(localStream));
                        }
                        this._callView.setRemoteStream('');
                        break;
                    case AvayaClientServices.Services.Call.MediaDirection.SEND_RECV:
                        localStream = mediaEngine.getVideoInterface().getLocalMediaStream(videoChannels[0].getChannelId());
                        if (AvayaClientServices.Base.Utils.isDefined(localStream)) {
                            this._callView.setLocalStream(URL.createObjectURL(localStream));
                        }
                        remoteStream = mediaEngine.getVideoInterface().getRemoteMediaStream(videoChannels[0].getChannelId());
                        if (AvayaClientServices.Base.Utils.isDefined(remoteStream)) {
                            this._callView.setRemoteStream(URL.createObjectURL(remoteStream));
                        }
                        break;
                    case AvayaClientServices.Services.Call.MediaDirection.INACTIVE:
                        break;
                    case AvayaClientServices.Services.Call.MediaDirection.DISABLE:
                        break;
                    default:
                        this._callView.setLocalStream('');
                        this._callView.setRemoteStream('');
                        break;
                }
            }
            else {
                this._callView.setLocalStream('');
                this._callView.setRemoteStream('');
            }
        },

        /**
         * Function parse WebCollabURL.
         *
         * @param {String} webCollabUrl
         * @returns {Object}
         * @private
         */
        _parseWcsConfig: function (webCollabUrl) {
            var wcsConfiguration;

            if (AvayaClientServices.Base.Utils.isDefined(webCollabUrl)) {
                var parsedWcsUrl = AvayaClientServices.Base.Utils.parseUrl(webCollabUrl);
                var isSecure = document.location.protocol === 'https:' || document.location.protocol === 'chrome-extension:';
                var restConfig = new AvayaClientServices.Config.ServerInfo(parsedWcsUrl.hostname, isSecure ? 443 : 80, isSecure);
                var params = parsedWcsUrl.query.split('&').map(function (param) {
                    var data = param.split('=');
                    return {key: data[0], value: data[1]};
                });

                params.getValue = function (key) {
                    var param = this.filter(function (p) {
                        return p.key === key;
                    });

                    if (param.length !== 0) {
                        return param[0].value;
                    } else {
                        return null;
                    }
                };
                var token = params.getValue('token');
                var meetingId = params.getValue('meeting_id');
                var mode = params.getValue('mode');
                var login = params.getValue('login').split('@')[0];
                var participantId = params.getValue('participantId');
                var credentialProvider = new AvayaClientServices.Config.WCSCredentialTokenProvider(token, params.getValue('login'), participantId, undefined, mode);

                wcsConfiguration = {
                    enabled: true,
                    meetingId: meetingId,
                    credentialProvider: credentialProvider,
                    networkProviderConfiguration: {
                        restConfig: restConfig
                    }
                };
            }

            return wcsConfiguration;
        },

        _startTimer: function () {
            this._timerInterval = setInterval(function () {
                this._time = this._time + 1;
                this._callView.refreshCallTimer(this._time);
            }.bind(this), 1000);
        },

        _pauseTimer: function () {
            clearInterval(this._timerInterval);
        },

        _stopTimer: function () {
            clearInterval(this._timerInterval);
            this._callView.clearCallTimer();
            this._time = 0;
        }
    };

    window.CallController = CallController;

})(window);
