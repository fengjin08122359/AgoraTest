(function (AvayaClientServices, window, $) {
    'use strict';

    function LoginController() {
        this._client = new AvayaClientServices();
        this._conferenceTokenHref = undefined;
        this._user = undefined;
        this._loginView = new window.LoginView({
            clientVersion: this._client.getVersion(),
            handleLogin: function (callSettings, messagingSettings, deviceServicesSettings) {
                this.login(callSettings, messagingSettings, deviceServicesSettings);
            }.bind(this),
            handleLogout: function () {
                this.logout();
            }.bind(this)
        });

        this._callsController = undefined;
        this._contactsController = undefined;
        this._messagingController = undefined;
    }


    LoginController.prototype = {
        /**
         * Register and login the user.
         *
         * @param {Object} callSettings
         * @param {Object} messagingSettings
         * @param {Object} deviceServicesSettings
         */
        login: function (callSettings, messagingSettings, deviceServicesSettings) {
            var callUserConfiguration = new AvayaClientServices.Config.CallUserConfiguration();
            callUserConfiguration.incomingCall = true;
            callUserConfiguration.videoEnabled = true;

            var config = {
                callUserConfiguration: callUserConfiguration
            };

            if (callSettings.address) {
                var callCredentialProvider = new AvayaClientServices.Config.CredentialProvider(callSettings.username, callSettings.password);
                var esgNetworkProviderConfig = new AvayaClientServices.Config.ServerInfo(callSettings.address, callSettings.port, callSettings.tls);
                config.sgConfiguration = {
                    enabled: true,
                    credentialProvider: callCredentialProvider,
                    networkProviderConfiguration: new AvayaClientServices.Config.NetworkProviderConfiguration(esgNetworkProviderConfig)
                };
                config.uccpConfiguration = {
                    enabled: true,
                    credentialProvider: null,
                    networkProviderConfiguration: {
                        webSocketConfig: {}
                    }
                };
                config.collaborationConfiguration = {
                    contentSharingWorkerPath: 'js/lib/AvayaClientServicesWorker.min.js'
                };
                config.wcsConfiguration = {
                    enabled: true
                };
                config.presenceConfiguration = {
                    enabled: true
                };
            }

            if (messagingSettings.address) {
                var messagingServicesCredentialProvider = new AvayaClientServices.Config.CredentialProvider(messagingSettings.username, messagingSettings.password);
                var ammNetworkProviderConfig = new AvayaClientServices.Config.ServerInfo(messagingSettings.address, messagingSettings.port, messagingSettings.tls);
                config.ammConfiguration = {
                    enabled: true,
                    allowPrevalidation: true,
                    pollingIntervalInMinutes: 1,
                    credentialProvider: messagingServicesCredentialProvider,
                    networkProviderConfiguration: new AvayaClientServices.Config.NetworkProviderConfiguration(ammNetworkProviderConfig)
                };
            }

            if (deviceServicesSettings.address) {
                var acsNetworkProviderConfig = new AvayaClientServices.Config.ServerInfo(deviceServicesSettings.address, deviceServicesSettings.port, deviceServicesSettings.tls);
                var acsCredentialProvider = new AvayaClientServices.Config.CredentialProvider(deviceServicesSettings.username, deviceServicesSettings.password);
                config.acsConfiguration = {
                    enabled: true,
                    credentialProvider: acsCredentialProvider,
                    networkProviderConfiguration: new AvayaClientServices.Config.NetworkProviderConfiguration(acsNetworkProviderConfig)
                };
            }

            this._client.registerLogger(window.console);

            this._user = this._client.createUser(config);

            this._user.addOnUserRegistrationSuccessful(function (href) {
                this._conferenceTokenHref = href;
            }.bind(this));

            this._initServices(this._user);

            this._user.start().then(function () {
                this._loginView.userRegistrationSuccessful();
                if (callSettings.address) {
                    this._loginView.activeCallTab();
                } else if (messagingSettings.address) {
                    this._loginView.activeMessagingTab();
                } else if (deviceServicesSettings.address) {
                    this._loginView.activeContactsTab();
                }
            }.bind(this), function () {
                this._loginView.userRegistrationFailed();
            }.bind(this));
        },

        /**
         * User un-registration/logout function
         */
        logout: function () {
            this._user.stop().then(function () {
                this._loginView.userUnregistrationSuccessful();
            }.bind(this), function () {
                this._loginView.userUnregistrationFailed();
            }.bind(this));
        },

        /**
         * Services initialization.
         *
         * @param {Object} user
         */
        _initServices: function (user) {
            if (user.getCalls()) {
                user.getCalls().addOnCallsServiceAvailableCallback(function () {
                    this._callsController = new window.CallsController(user, this._client);
                    this._loginView.showCallTab();
                }.bind(this));
            }
            if (user.getContacts()) {
                user.getContacts().addOnContactsServiceAvailableCallback(function () {
                    this._contactsController = new window.ContactsController(user);
                    this._loginView.showContactsTab();
                }.bind(this));
            }
            if (user.getMessaging()) {
                user.getMessaging().addOnMessagingServiceAvailableCallback(function () {
                    this._messagingController = new window.MessagingController(user);
                    this._loginView.showMessagingTab();
                }.bind(this));
            }
        }
    };

    window.LoginController = LoginController;

})(AvayaClientServices, window, jQuery);
