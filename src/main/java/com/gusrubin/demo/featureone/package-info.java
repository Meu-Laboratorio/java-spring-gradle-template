/**
 * @author Gustavo Rubin
 */
@ApplicationModule(
    displayName = "Feature One",
    type = OPEN,
    allowedDependencies = {"infrastructure"}

)
package com.gusrubin.demo.featureone;

import static org.springframework.modulith.ApplicationModule.Type.OPEN;

import org.springframework.modulith.ApplicationModule;