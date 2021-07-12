# trackingplan-ios

- [ x] Make sure installing that after installing tp, everything is not blocking the main thread (or anything!)
- [ x]Try Catch everything. App should not ever be broken by this package. VERY IMPORTANT!
- [ x] Shared member (singleton I guess), so trackingplan object can be accessed through Trackingplan.shared() anywhere in the app. i.e. for stopping it. PTAL at how NetworkInterceptor itself does it, or mimic how other analytics do it.
- [x ] Add swift packages support
- [x] Find out the swift version that is safe for pods and use that version functions
- [ ]Ensure this is compatible with ObjC apps.
- [x] Actually publish at cocoapods
- [ ] Install instructions at the readme. Add example of usage of how to initialize and include.
- [x] Batching: when we sent the batch: after reaching xKbs, app goes to background, something else?
- [x] Sampling
- [-] Make sure code is elegant and readable for experienced developers.
- [x] Trackingplan uses some other dependencies. Join all dependencies in the same package.
- [Oleg] Review edge use cases, is we run the code from another thread?
- [ ] Make sure to test all use cases: endpoint not responding, 404, server error etc.
- [ ] Improve logging, remove prints.
- [ ] Que pasa si me quedo sin conectividad.
