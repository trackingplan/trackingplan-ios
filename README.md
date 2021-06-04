# trackingplan-ios

- [ ] Make sure installing that after installing tp, everything is not blocking the main thread (or anything!)
- [ ]Try Catch everything. App should not ever be broken by this package. VERY IMPORTANT!
- [ ] Shared member (singleton I guess), so trackingplan object can be accessed through Trackingplan.shared() anywhere in the app. i.e. for stopping it. PTAL at how NetworkInterceptor itself does it, or mimic how other analytics do it.
- [ ] Add swift packages support
- [ ] Add Carthage support.
- [ ] Find out the swift version that is safe for pods and use that version functions
- [ ]Ensure this is compatible with ObjC apps.
- [ ] Improve logging, not print.
- [ ]Actually publish at cocoapods and add install instructions at the readme.
- [ ]Batching: when we sent the batch: after reaching xKbs, app goes to background, something else?
- [ ]Sampling
- [ ]Make sure code is elegant and readable for experienced developers. 

