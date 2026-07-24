type IProps = Readonly<{
  title: string;
}>;

const MainTitle = ({ title }: IProps) => {
  return <h6 className="font-bold text-forest-green-900">{title}</h6>;
};

export default MainTitle;
