/-  spider
/+  *ph-io
=,  strand=strand:spider
^-  thread:spider
|=  vase
=/  m  (strand ,vase)
;<  az=tid:spider
  bind:m  start-azimuth
;<  ~  bind:m  (spawn az ~bud)
;<  ~  bind:m  (spawn az ~dev)
;<  ~  bind:m  (real-ship az ~bud)
;<  ~  bind:m  (real-ship az ~dev)
;<  ~  bind:m  (send-hi ~bud ~dev)
;<  ~  bind:m  end-azimuth
(pure:m *vase)
