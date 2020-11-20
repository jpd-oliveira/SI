:-ensure_loaded('RTXEngine/RTXstrips_planner').

act stack(X,Y)
   pre [ clear(Y), holding(X)        ]
   add [ on(X,Y), clear(X), handempty]
   del [ clear(Y), holding(X)        ]
   endcond[].

act unstack(X,Y)
   pre [ on(X,Y), clear(X),handempty]
   add [ clear(Y), holding(X)       ]
   del [ on(X,Y), clear(X),handempty]
   endcond[].


act pickup(X)
   pre [ ontable(X), clear(X),handempty ]
   add [ holding(X)                     ]
   del [ ontable(X), clear(X), handempty]
   endcond[].


act putdown(X)
   pre [ holding(X)                      ]
   add [ ontable(X), clear(X), handempty ]
   del [ holding(X)                      ]
   endcond[].

