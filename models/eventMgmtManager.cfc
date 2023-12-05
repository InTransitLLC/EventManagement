component {
    property name='EventMgmtDAO' inject='EventMgmtDAO@EventManagement';

    public any function save(required any arr,required any bean){
        return EventMgmtDAO.save(arr=arguments.arr,eventBean=arguments.bean);
    }

    public any function get(required any bean){
        return EventMgmtDAO.get(bean=arguments.bean);
    }

}