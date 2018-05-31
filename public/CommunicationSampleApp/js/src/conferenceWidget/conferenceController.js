(function (window, $) {
    'use strict';

    function ConferenceController(call, uccpConfig, template) {
        this._call = call;
        this._conference = this._call.getConference();
        this._conferenceChat = undefined;
        this._isConferenceMuted = false;
        this._participants = [];
        this._template = template;

        this._conferenceView = new window.ConferenceView(this._template, {
            handleLockUnlockConference: function () {
                this.lockConference();
            }.bind(this),
            handleMuteUnmuteAll: function () {
                this.muteAll();
            }.bind(this),
            handleLeaveConference: function () {
                this.leaveConference();
            }.bind(this)
        });

        this._init(uccpConfig);
    }


    ConferenceController.prototype = {
        /**
         * Init function for Conference.
         * Registration callbacks releated with Conference.
         */
        _init: function (uccpConfig) {
            this._call.addOnCallEndedCallback(function () {
                console.log('Client: CallEnded');
                this._conferenceView.hideConferencePanels();
            }.bind(this));

            this._conference.addOnConferenceLockStatusChangedCallback(function (conference, isLocked) {
                console.log('Client: ConferenceLockStatus', conference, isLocked);
                this._conferenceView.changeLockUnlockBtn(isLocked);
            }.bind(this));

            this._conference.addOnConferenceAllParticipantsMutedCallback(function (conference) {
                console.log('Client: ParticipantsMuted', conference);
                this._isConferenceMuted = true;
                this._conferenceView.changeMuteUnmuteAllBtn(true);
            }.bind(this));

            this._conference.addOnConferenceAllParticipantsUnmutedCallback(function (conference) {
                console.log('Client: ParticipantsUnmuted', conference);
                this._isConferenceMuted = false;
                this._conferenceView.changeMuteUnmuteAllBtn(false);
            }.bind(this));

            this._conference.addOnConferenceParticipantsAddedCallback(function (conference, participants) {
                console.log('Client: ParticipantsAdded', conference, participants);
                participants.forEach(function (participant) {
                    participant.addOnParticipantVideoStatusChangedCallback(function (participant) {
                        this._updateParticipantRoster(participant);
                    }.bind(this));
                    participant.addOnParticipantAudioStatusChangedCallback(function (participant) {
                        this._updateParticipantRoster(participant);
                    }.bind(this));

                    this._participants.push(participant);
                    this._conferenceView.addParticipantToRoster(participant.getParticipantId(), participant.getDisplayName(), participant.isVideoBlocked(), participant.isAudioMuted());
                }.bind(this));
            }.bind(this));

            this._conference.addOnConferenceParticipantsRemovedCallback(function (conference, participants) {
                console.log('Client: ParticipantsRemoved', conference, participants);
                participants.forEach(function (participant) {
                    this._conferenceView.removeParticipantFromRoster(participant.getParticipantId());
                }.bind(this));
            }.bind(this));

            this._conference.start(uccpConfig).then(function () {
                console.log("Client: Call conference started.");
                this._conferenceView.showConferencePanels();
                this._conferenceChat = new window.ConferenceChatController(this._call, this._conference, this._template);
            }.bind(this));
        },

        /**
         * Function used to leave from conference.
         */
        leaveConference: function () {
            this._call.end();
        },

        /**
         * Function used to mute all participants in conference.
         */
        muteAll: function () {
            if (this._isConferenceMuted) {
                this._conference.unmuteAllParticipants();
            } else {
                this._conference.muteAllParticipants();
            }
        },

        /**
         * Function used to lock conference.
         */
        lockConference: function () {
            if (this._conference.isLocked()) {
                this._conference.setLocked(false);
            } else {
                this._conference.setLocked(true);
            }
        },

        /**
         * Function update participants roster label.
         *
         * @param participant
         * @private
         */
        _updateParticipantRoster: function (participant) {
            this._conferenceView.updateParticipantInRoster(participant.getParticipantId(), participant.getDisplayName(), participant.isVideoBlocked(), participant.isAudioMuted());
        }

    };

    window.ConferenceController = ConferenceController;

})(window, jQuery);
