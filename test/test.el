(require 'justl)
(require 'ert)

(ert-deftest just--get-recipies-test ()
  (should (equal (list "default" "build-cmd" "push" "push2") (just--get-recipies))))

(ert-deftest just--list-to-recipe-test ()
  (should (equal (jrecipe-name (just--list-to-jrecipe (list "recipe" "arg"))) "recipe"))
  (should (equal (jrecipe-name (just--list-to-jrecipe (list "recipe"))) "recipe"))
  (should (equal (jrecipe-args (just--list-to-jrecipe (list "recipe"))) nil)))

(ert-deftest just--is-recipe-line-test ()
  (should (equal (just--is-recipe-line "default:") t))
  (should (equal (just--is-recipe-line "build-cmd version='0.4':") t))
  (should (equal (just--is-recipe-line "push version: (build-cmd version)") t))
  (should (equal (just--is-recipe-line "    just --list") nil)))

(ert-deftest just--find-justfiles-test ()
  (should (equal (length (just--find-justfiles ".")) 1)))

(ert-deftest just--get-recipe-name-test ()
  (should (equal (just--get-recipe-name "default") "default"))
  (should (equal (just--get-recipe-name "build-cmd version='0.4'") "build-cmd"))
  (should (equal (just--get-recipe-name "push version:") "push"))
  (should (equal (just--get-recipe-name "push version1 version2") "push")))

(ert-deftest just--str-to-jarg-test ()
  (should (equal (just--str-to-jarg "version=0.4") (list (make-jarg :arg "version" :default "0.4"))))
  (should (equal (just--str-to-jarg "version='0.4'") (list (make-jarg :arg "version" :default "'0.4'"))))
  (should (equal (just--str-to-jarg "version='0.4' version2") (list (make-jarg :arg "version" :default "'0.4'")
                                                                    (make-jarg :arg "version2" :default nil))))
  (should (equal (just--str-to-jarg "version version2") (list (make-jarg :arg "version" :default nil)
                                                              (make-jarg :arg "version2" :default nil))))
  (should (equal (just--str-to-jarg "") nil))
)

(ert-deftest just--parse-recipe-test ()
  (should (equal (just--parse-recipe "default:") (make-jrecipe :name "default" :args nil)))
  (should (equal (just--parse-recipe "build-cmd version='0.4':")
                 (make-jrecipe :name "build-cmd" :args (list (make-jarg :arg "version" :default "'0.4'")))))
  (should (equal (just--parse-recipe "push version: (build-cmd version)")
                 (make-jrecipe :name "push" :args (list (make-jarg :arg "version" :default nil)))))
)

(ert "just--*")