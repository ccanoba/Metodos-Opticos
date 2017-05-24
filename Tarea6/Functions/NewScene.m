function NewScene(Fig, u, L, MarkerColor, MarkerSize, LineSize, axisrange)

figure(Fig)

plot(u(1,:),u(2,:),MarkerColor,'MarkerSize',MarkerSize);

hold on
for j=1:size(L,1),
  line([u(1,L(j,:))],[u(2,L(j,:))],'LineWidth',LineSize,'Color',MarkerColor(2));
end  

axis ij
axis equal
axis(axisrange)
grid on;