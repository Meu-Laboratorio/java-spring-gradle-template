package com.gusrubin.demo;

import org.junit.jupiter.api.Test;
import org.springframework.modulith.core.ApplicationModules;
import org.springframework.modulith.docs.Documenter;
import org.springframework.modulith.docs.Documenter.CanvasOptions;
import org.springframework.modulith.docs.Documenter.DiagramOptions;
import org.springframework.modulith.docs.Documenter.DiagramOptions.DiagramStyle;

/**
 * Tests to verify the modular structure and generate documentation for the modules.
 *
 * @author Gustavo Rubin
 */
class ModularityTests {

  ApplicationModules modules = ApplicationModules.of(DemoApplication.class);

  @Test
  void verifiesModularStructure() {
    modules.verify();
  }

  @Test
  void createModuleDocumentation() throws Exception {

    var canvasOptions = CanvasOptions.defaults()

        // --> Optionally enable linking of JavaDoc
        // .withApiBase("https://foobar.something")

        ;

    var docOptions = DiagramOptions.defaults().withStyle(DiagramStyle.UML);

    new Documenter(modules) //
        .writeDocumentation(docOptions, canvasOptions);
  }

}
