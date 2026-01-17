/**
 * @author Gustavo Rubin
 */
@ApplicationModule(
    displayName = "Feature Two",
    allowedDependencies = {"featureone", "infrastructure"}
)
package com.gusrubin.demo.featuretwo;

import org.springframework.modulith.ApplicationModule;